require 'spec_helper'

describe LineItem do
  fixtures :all
  
  before do
    @order = orders(:pending_order)
    @ontario_cust = addresses(:adrian)
    @ny_cust = addresses(:un) 
  end

  it "should charge HST when billing to ontario" do
    @order.add(products(:tiny_digital_man)) # $29.99
    li = @order.line_items.last
    products(:tiny_digital_man).id.should == li.product.id
    li.applicable_tax_rate(@ontario_cust).should == 18.0
    li.total_tax(@ontario_cust).round(2).should == 5.40
    li.total_price_with_tax(@ontario_cust).round(2).should == 35.39
  end

  it "should calculate tax correctly when there are multiple items" do
    @order.add(products(:tiny_digital_man), 2) # $59.98
    li = @order.line_items.last
    products(:tiny_digital_man).id.should == li.product.id
    li.applicable_tax_rate(@ontario_cust).should == 18.0
    li.total_tax(@ontario_cust).round(2).should == 10.80
    li.total_price_with_tax(@ontario_cust).round(2).should == 70.78
  end

  it "should charge NY sales tax when billing to new york" do
    @order.add(products(:map_of_peninsula)) # $10.00
    li = @order.line_items.last
    products(:map_of_peninsula).id.should == li.product.id
    li.applicable_tax_rate(@ny_cust).should == 3.0
    li.total_tax(@ny_cust).should == 0.30
    li.total_price_with_tax(@ny_cust).should == 10.30
  end

  it "should not charge tax when no tax exists for the destination" do
    @order.add(products(:book_of_bad_puns)) # $10.00
    li = @order.line_items.last
    li.applicable_tax_rate(@ny_cust).should == 0.0
    li.total_tax(@ny_cust).should == 0.0
    li.total_price_with_tax(@ny_cust).should == 100.0
  end

  it "should not charge tax when no tax exists for the product" do
    @order.add(products(:shovel)) # $10.00
    li = @order.line_items.last
    li.applicable_tax_rate(@ny_cust).should == 0.0
    li.total_tax(@ny_cust).should == 0.0
    li.total_price_with_tax(@ny_cust).should == 5.0
  end

end
