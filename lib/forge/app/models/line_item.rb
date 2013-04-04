class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  validates_presence_of :order_id, :product_id
  validates_numericality_of :price
  validates_numericality_of :quantity, :greater_than => 0

  attr_accessible :quantity

  def total_price
    quantity * price
  end

  def total_tax(billing_address)
    total_price * (applicable_tax_rate(billing_address) / 100.0).round(2)
  end

  def total_price_with_tax(billing_address)
    total_price + total_tax(billing_address)
  end 

  # collect all of the applicable tax rates based on where the person purchasing it is located,
  # then enumerate through them and add up their rates
  def applicable_tax_rate(billing_address)
    raise "billing address must be an Address" unless billing_address.kind_of? Address
    applicable_tax_rates = self.product.tax_rates.find_all_by_country_id(billing_address.country_id)
    applicable_tax_rates += self.product.tax_rates.find_all_by_province_id(billing_address.province_id) if billing_address.province_id
    # use uniq to ensure we don't charge tax too many times - it's possible to get overlapping rates between a country and its provinces
    applicable_tax_rates.uniq.inject(0.0) { |sum, applicable_tax_rate| sum += applicable_tax_rate.rate }
  end

end
