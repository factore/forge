class Order < ActiveRecord::Base
  include AASM
  require 'active_shipping'
  include ActiveMerchant::Shipping
  include ActiveMerchant::Billing

  has_many :line_items
  has_many :products, :through => :line_items
  belongs_to :shipping_address, :class_name => 'Address'
  belongs_to :billing_address, :class_name => 'Address'
  has_many :transactions, :class_name => 'OrderTransaction', :dependent => :destroy

  attr_accessible :line_items_attributes

  accepts_nested_attributes_for :line_items, :reject_if => proc { |attributes| attributes['quantity'].blank? }

  scope :not_pending, where("state != 'pending'")

  validates_presence_of :key
  validates_uniqueness_of :key
  validates_presence_of :state

  after_save :remove_empty_line_items

  attr_accessor :shipping_rates

  # the normal flow for credit card processing is: pending, authorized, paid, fulfilled
  # however, for paypal it is: pending, paid, fulfilled
  aasm_column         :state
  aasm_initial_state  :pending
  aasm_state          :pending
  aasm_state          :authorized
  aasm_state          :paid,  :enter => :email_receipt
  aasm_state          :fulfilled
  aasm_state          :failed

  aasm_event      :pay do
    transitions   :to => :paid,         :from => [:pending, :authorized, :failed]
  end
  aasm_event      :authorize do
    transitions   :to => :authorized,   :from => [:pending, :failed]
  end
  aasm_event      :fulfill do
    transitions   :to => :fulfilled,    :from => :paid
  end
  aasm_event      :unfulfill do
    transitions   :to => :paid,    :from => :fulfilled
  end
  aasm_event      :fail do
    transitions   :to => :failed,       :from => :pending
  end

  def invoice_id
    invoice = MySettings.paypal_invoice_prefix.blank? ? "" : MySettings.paypal_invoice_prefix
    invoice += id.to_s
    return invoice
  end

  def price
    self.line_items.inject(0.0) { |sum, line_item| sum + line_item.total_price }
  rescue NoMethodError
    nil
  end

  def price_with_tax
    price + tax
  end

  def total_price
    (price_with_tax + shipping + handling) - discount
  end

  def total_price_in_cents
    (total_price * 100.0).to_i
  end

  def tax
    # raise "A valid billing address must exist in order to calculate the tax" if self.billing_address.blank? || !self.billing_address.valid?
    self.line_items.inject(0.0) { |sum, line_item| sum += line_item.total_tax(self.billing_address) }
  end

  # TODO: make this work
  def discount
    0
  end

  def shipping
    amount = 0.0
    # raise "A valid shipping address must exist in order to calculate the shipping" if self.shipping_address.blank? || !self.shipping_address.valid?
    if Forge::Settings[:flat_rate_shipping]
      amount = self.line_items.inject(0.0) { |sum, line_item| sum += (line_item.quantity * line_item.product.flat_rate_shipping) }
    elsif self.shipping_cost
      amount = self.shipping_cost
    else
      @shipping_rates = shipping_quote if @shipping_rate.nil?
      amount = @shipping_rates[0][:price] unless @shipping_rates.nil?
      self.shipping_cost = amount
      self.save
    end
    amount
  end

  # OPTIMIZE: this method is excessively long and could be decomposed into several other methods
  def shipping_quote
    shipper = MySettings.shipper
    if !shipper.blank?
      # Create packages array containing a package of each order item. (What to do with multiples of the same item?)
      packages = []
      self.line_items.each do |item|
        product = item.product
        for i in (1..item.quantity)
          packages.push( Package.new(
              product.weight,
              [product.width, product.height, product.depth],
              :value => product.price
            )
          )
        end
      end

      # Set up Origin and Destination
      origin = Location.new(
        :country => MySettings.origin_country,
        :province => MySettings.origin_province,
        :city => MySettings.origin_city,
        :postal_code => MySettings.origin_postal
      )
      add = self.shipping_address
      destination = Location.new(
        :country => add.country.code,
        :province => add.province.title,
        :city => add.city,
        :postal_code => add.postal
      )

      # Run functions to get cost estimates
      shipper = "ActiveMerchant::Shipping::#{MySettings.shipper.underscore.parameterize('_').camelize}".constantize.new(Forge::Settings[Rails.env.to_sym][MySettings.shipper.underscore.parameterize("_").to_sym])
      begin
        response = shipper.find_rates(origin, destination, packages)
        # Store all rates, order by price. Return cheapest rate.
        rates = response.rates.sort_by(&:price).collect {|rate| {:service => rate.service_name, :price => rate.price/100.0}}
      rescue ActiveMerchant::Shipping::ResponseError => e
        # Error response
        rates = nil
      end
    else
      #No shipper has been defined
    end

    return rates
  end

  # whether or not the order can currently calculate shipping
  def can_calculate_shipping?
    !self.shipping_address.blank? && self.shipping_address.valid?
  end

  def can_calculate_tax?
    !self.billing_address.blank? && self.billing_address.valid?
  end

  def handling
    MySettings.handling.to_f || 0
  end

  def shipping_and_handling
    shipping + handling
  end

  def add(product, quantity = 1)
    quantity = quantity.to_i
    if quantity < 1
      self.line_items.delete(self.line_items.find_by_product_id(product.id))
    else
      if product.published?
        if !self.products.include?(product)
          li = LineItem.new(:quantity => quantity)
          li.product_id = product.id # product is protected against mass assignment
          li.price = product.price # price is protected against mass assignment
          self.line_items << li
        else
          li = self.line_items.find_by_product_id(product.id)
          li.quantity += quantity
          li.save
        end
      end
    end
  end

  def create_key!
    self.key = generate_key
    until Order.find_by_key(self.key).nil?
      self.key = generate_key
    end
    self.save!
    self.key
  end

  def valid_addresses?
    self.billing_address && self.billing_address.valid? && self.shipping_address && self.shipping_address.valid?
  end

  # for capturing PayPal notifications
  def self.capture_payment(raw_post)
    notify = Paypal::Notification.new(raw_post)
    MySettings.paypal_invoice_prefix.empty? ? invoice_num = notify.invoice : invoice_num = notify.invoice.gsub(MySettings.paypal_invoice_prefix, "")
    order = Order.find(invoice_num)
    if order
      if notify.acknowledge
        begin
          if notify.complete?
            order.pay!
          else
            order.fail!
          end
        rescue => e
          order.fail!
        end
      end
      order.save
      order
    end
  end

  # TODO: should total_price be multiplied by 100 to be in cents?
  def authorize_payment(credit_card, options = {})
    options[:order_id] = self.id
    transaction do
      authorization = OrderTransaction.authorize(total_price_in_cents, credit_card, options)
      transactions.push(authorization)
      if authorization.success?
        authorize!
      else
        fail!
      end
      authorization
    end
  end

  def capture_payment(options = {})
    transaction do
      capture = OrderTransaction.capture(total_price_in_cents, authorization_reference, options)
      transactions.push(capture)
      if capture.success?
        pay!
      else
        fail!
      end
      capture
    end
  end

  def authorization_reference
    if authorization = transactions.find_by_action_and_success('authorization', true, :order => 'id ASC')
      authorization.reference
    else
      nil
    end
  end

  protected

    def remove_empty_line_items
      self.line_items.select {|item| item.quantity == 0}.each {|item| item.destroy}
    end

  private

    def generate_key
      self.key = UUIDTools::UUID.random_create.to_s
    end

    def email_receipt
      if Forge::Settings[:email_receipt]
        ReceiptMailer.receipt(self).deliver
      end
    end

end
