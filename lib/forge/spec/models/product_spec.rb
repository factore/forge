require 'spec_helper'

describe Product do
  fixtures :product_categories, :tax_rates

  # About Product:
  # 
  # - has and belongs to many tax_rates
  # - has many images
  # - has and belongs to many product_categories
  # - has many coupons
  # 
  # - must have a title
  # - must have a category (so they show up on the products list)
  # - must have a short description and description if it is published
  # - price, shipping and weight default to 0.00
  # - price, shipping and weight must be numerical
  # - price, shipping and weight must be >= 0.00

  # relationships
  it { should have_and_belong_to_many :tax_rates }
  it { should belong_to :product_category }
  it { should have_many :images }
  
  #validations
  it { should validate_presence_of :title }
  it { should validate_presence_of :product_category }
  it { should validate_numericality_of :price }
  it { should validate_numericality_of :weight }
  it { should validate_numericality_of :width }
  it { should validate_numericality_of :height }
  it { should validate_numericality_of :depth }
 
  describe "the basics" do

    it "should ensure product has a short description if published" do
      product = Product.create(:published => true)
      product.should have(1).errors_on(:short_description)
    end
    
    it "should ensure product has a description if published" do
      product = Product.create(:published => true)
      product.valid?
      product.should have(1).errors_on(:description)
    end
      
    it "should ensure price defaults to zero" do
      product = Product.new
      product.price.should == 0.00
    end

    it "should ensure weight defaults to zero" do
      product = Product.new
      product.weight.should == 0.00
    end
    
    it "should ensure price is not less than zero" do
      product = Product.new(:price => -0.01)
      product.valid?.should_not == true
      product.should have(1).errors_on(:price)
    end

  end

# TODO: re-enable these tests
=begin  
  it "should weight cannot be less than zero" do
    product = Product.new(:weight => -0.01)
    product.valid?
    product.errors.invalid?(:weight), "weight cannot be less than zero".should_not == nil
  end	
  
  it "should shipping cannot be less than zero" do
    product = Product.new(:shipping => -0.01)
    product.valid?
    product.errors.invalid?(:shipping), "shipping cannot be less than zero".should_not == nil
  end	
  
 it "should shipping should default to zero" do
    product = Product.new
    product.shipping.should == 0.00
  end
=end

end
