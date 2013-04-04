module Forge

  class CreditCardProcessor

    include ActiveMerchant::Billing

    attr_reader :status, :message, :credit_card

    def initialize(order, currency = "CAD")
      @order = order
      @currency = currency
    end

    def create_credit_card(args)
      @credit_card = ActiveMerchant::Billing::CreditCard.new(
        :first_name => @order.billing_address[:first_name],
        :last_name => @order.billing_address[:last_name],
        :month => args[:month],
        :year => args[:year],
        :verification_value => args[:verification_value],
        :number => args[:number]
      )
    end

    def pay(order)
      raise "Credit card cannot be nil" if @credit_card.nil?

      # build the options hash for the payment
      options = options_hash("Order ## #{order.id}")
      if @credit_card.valid?
        authorization = order.authorize_payment(@credit_card, options)
        if authorization.success? && order.authorized?
          # proceed to capture payment
          capture = order.capture_payment
          if capture.success? && order.paid?
            @message = "Successfully charged $#{sprintf("%.2f", order.total_price)} to the credit card #{credit_card.display_number}"
          else
            @status = :failure
            @message = "Payment capture failed.  Please contact your credit card company to determine the problem, or retry with a different card."
          end
        else
          # could not authorize
          @status = :failure
          @message = "Payment authorization failed.  Please contact your credit card company to determine the problem, or retry with a different card."
        end
        @status = @order.state.to_sym
      else
        @status = :invalid_credit_card
        @message = "The credit card number you have entered is not valid."
      end
      if @status == :paid
        true
      else
        false
      end
    end

    private

    # used for billing address, but can also be used for shipping address
    def options_from_addressed_object(object)
      options = {}
      if object
        cc = ActiveMerchant::Country::COUNTRIES.detect {|c| c[:name] == object[:country]}
        code = cc.nil? ? "" : cc[:alpha2]
        options = {
          :name => "#{object[:first_name]} #{object[:last_name]}",
          :address1 => object[:address1],
          :address2 => object[:address2],
          :city => object[:city],
          :state => object[:province],
          :zip => object[:postal],
          :phone => object[:phone],
          :country => code # get their country code
        }
      end
      options
    end

    def options_hash(description)
      options = {}
      options[:description] = description
      options[:currency] = @currency
      options[:customer] = "#{@order.billing_address[:first_name]} #{@order.billing_address[:last_name]}"
      options[:email] = @order.billing_address[:email]
      options[:billing_address] = options_from_addressed_object(@order.billing_address)
      options[:shipping_address] = options_from_addressed_object(@order.shipping_address)
      options
    end

  end

end
