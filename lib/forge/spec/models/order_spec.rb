require 'spec_helper'

describe Order, "adding to cart" do
  fixtures :all


  before do
    @cart_order = create_order
  end

  it "should add to cart" do
    product_count = @cart_order.products.size
    @cart_order.add(products(:book_of_bad_puns))
    (product_count + 1).should == @cart_order.products.size
    @cart_order.add(products(:tiny_digital_man))
    2.should == @cart_order.products.size
    @cart_order.add(products(:book_of_bad_puns), 2)
    @cart_order.reload
    assert_equal @cart_order.products.size, 2, "The number of items should not increase since this product is already in the cart." 
    assert_equal @cart_order.price, 329.99, "three times 100.0 plus 29.99" 
  end

  it "should test retrieve standard info" do
    @cart_order.add(products(:book_of_bad_puns))
    products(:book_of_bad_puns).id.should == @cart_order.line_items.last.product_id
    1.should == @cart_order.line_items.last.quantity
    products(:book_of_bad_puns).id.should == @cart_order.products.last.id
    products(:book_of_bad_puns).title.should == @cart_order.products.last.title
  end

  it "should remove products when the quantity is set to zero" do
    @cart_order.add(products(:tiny_digital_man), 10)
    @cart_order.line_items.last.quantity.should == 10
    @cart_order.line_items.size.should == 1
    @cart_order.add(products(:tiny_digital_man), 0)
    @cart_order.reload
    assert_equal @cart_order.line_items.size, 0, "adding a product with quantity of zero should remove it from the order"
  end

end

describe Order, "shipping and handling when shipping is a flat rate" do
  fixtures :all

  before do
    @order = create_order
    @order.shipping_address = addresses(:adrian)
    MySettings.handling = 5.00
    Forge::Settings[:flat_rate_shipping] = true
  end

  it "should include the handling fee by default" do
    @order.handling.should == 5.00
  end

  it "should calculate shipping as a function of product flat shipping rates" do
    @order.add(products(:book_of_bad_puns))
    @order.shipping_and_handling.should == (5.00 + 8.00)
    @order.add(products(:tiny_digital_man), 2)
    @order.shipping_and_handling.should == (5.00 + 8.00 + (3.00 * 2.0))
  end

  it "should calculate shipping and handling together" do
    @order.add(products(:tiny_digital_man), 2)
    @order.shipping_and_handling.should == (5.00 + (3.00 * 2.0))
  end

end

describe Order, "shipping and handling when shipping is not a flat rate" do
  fixtures :all

  before do
    @order = create_order
    @order.add(products(:book_of_bad_puns), 2) # 2 * $100 = $200 + 13% HST
    @order.add(products(:map_of_peninsula)) # $10 + 13% HST and 3% NY Sales Tax
    @order.shipping_address = addresses(:adrian)
    MySettings.handling = 8.00
    Forge::Settings[:flat_rate_shipping] = true
  end

  it "should include the handling fee by default" do
    @order.handling.should == 8.00
  end

  it "should calculate shipping as a function of product dimensions, weight, origin and destination" do
    MySettings.origin_country = "CA"
    MySettings.origin_province = "ON"
    MySettings.origin_city = "Hamilton"
    MySettings.origin_postal = "L8P 2B4"
    MySettings.shipper = "CanadaPost"
    @order.shipping.to_i.should == 16 # NOTE: this may change because Canada Post's shipping rates might change, which is why we're using an approximate (an integer)
  end

end

describe Order, "taxes" do
  fixtures :all

  before do
    @ontario_cust = addresses(:adrian)
    @ny_cust = addresses(:un)
    @order = create_order
    @order.add(products(:book_of_bad_puns), 2) # 2 * $100 = $200 + 13% HST
    @order.add(products(:map_of_peninsula)) # $10 + 13% HST and 3% NY Sales Tax
    # add another item that only has NY sales tax
    
    # add another item that has no sales tax
  end

  # TODO: $xxx in products
  it "should calculate proper taxes when billing to an ontario customer" do

  end

  it "should calculate proper taxes when billing to a new york customer" do

  end

end

def create_order
  order = Order.new
  order.create_key!
  order
end
