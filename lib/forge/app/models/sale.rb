class Sale < ActiveRecord::Base
  has_many  :products
  has_many  :product_categories

  validates_presence_of :title, :description, :start, :end
  validates_numericality_of :value


  # Define the types of sale calculation
  @@sale_types =   {:fixed => "All products in this sale are set to the same price. (e.g. Sale = $5.50: Product A = $5.50, Product B = $5.50",
                  :percentage => "All products in this sale are reduced by a percentage of their regular price. (e.g. Sale = 10%: Product A = $20 - $20/10 = $18",
                  :reduction => "All products are reduced by a set price. (e.g. Sale = $3: Product A = $20 - $3 = $17"}
  def self.sale_types
    @@sale_types
  end

  # Calculate sale price based on product options and sale rules
  def fixed(opts = {})
    self.value
  end

  def percentage(opts = {})
    opts[:price] - opts[:price]/value
  end

  def reduction(opts = {})
    opts[:price] - value
  end

  def price(opts = {})
    # Call the relevant sale calculator
    # It should be enough to call this from the product with product.sale.price({:price => product.price})
    m = self
    fp = m.method(m.sale_type.intern) # 'Function' Pointer
    fp.call(opts)
  end

  def product_ids
    self.products.map { |p| p.id }
  end
end
