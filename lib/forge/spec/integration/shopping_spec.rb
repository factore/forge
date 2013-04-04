require 'spec_helper'

describe "Shopping" do
  fixtures :all

  before(:each) do
    Order.destroy_all
    get "/products"
    response.should be_success, response.body
  end

  it "should shop for products" do 
    product = products(:book_of_bad_puns)
    get "/products/#{product.id}"
    assert_response :success
    
    # add an item to the cart
    lambda do
      post_via_redirect(add_to_cart_orders_path, { :product_id => product.id, :quantity => 2}, { "HTTP_REFERER" => "/products/#{product.id}" } )
      response.should be_success
    end.should change(Order, :count)

    flash[:notice].should == "Factore's Bad Puns was added to your cart."
    #
    # note that although you can use cookies[:order_key] in your controller, in your tests you must refer to it as follows
    cookies['order_key'].should_not == nil
    @order = Order.find_by_key(cookies['order_key'])
    1.should == @order.products.size

    @order.reload
    1.should == @order.line_items.size
    2.should == @order.line_items.first.quantity
    product.price.should == @order.line_items.first.price
    (product.price * 2.0).should == @order.price
    1.should == @order.products.size
   
    # add another item to the cart
    post_via_redirect(add_to_cart_orders_path, { :product_id => products(:tiny_digital_man).id, :quantity => 1}, { "HTTP_REFERER" => "/products/#{product.id}" } )
    assert_response :success
    @order.reload
    2.should == @order.line_items.size
    ((product.price * 2) + products(:tiny_digital_man).price).should == @order.price

    # add an item to the cart but neglect to enter a quantity
    post_via_redirect(add_to_cart_orders_path, { :product_id => products(:map_of_peninsula).id }, { "HTTP_REFERER" => "/products/#{product.id}" } )
    assert_response :success
    flash[:warning].should_not == nil
    @order.reload
    assert_equal @order.line_items.size, 2, "the quantity of line items should stay the same, because this addition should have failed" 

    # proceeding to checkout
    get orders_checkout_path
    response.should be_success, response.body

    post_via_redirect(orders_checkout_path, { :checkout => 1, :use_billing_for_shipping => "1", :billing_address => addresses(:incomplete).attributes }, { "HTTP_REFERER" => "/orders/checkout" })
    response.should be_success, response.body
    response.should render_template("checkout") # should still be stuck here
    assigns[:billing_address].errors.size.should == 2

    post_via_redirect(orders_checkout_path, { :checkout => 1, :use_billing_for_shipping => "1", :billing_address => addresses(:adrian).attributes }, { "HTTP_REFERER" => "/orders/checkout" } )
    response.should be_success, response.body
    response.should render_template("payment")
  end

  context "paying for items" do

    setup do
      @product = products(:book_of_bad_puns)
      get "/products/#{product.id}"
      assert_response :success
      
      # add an item to the cart
      lambda do
        post_via_redirect(add_to_cart_orders_path, { :product_id => @product.id, :quantity => 2}, { "HTTP_REFERER" => "/products/#{@product.id}" } )
        response.should be_success
      end.should_not change(Order, :count)

      @order.reload
      1.should == @order.line_items.size
    end

    it "should choose to pay with paypal" do
      Forge::Settings[:integrated_payments] = false

      # add an item to the cart
      product = products(:book_of_bad_puns)
      lambda do
        post_via_redirect(add_to_cart_orders_path, { :product_id => product.id, :quantity => 2}, { "HTTP_REFERER" => "/products/#{product.id}" } )
        response.should be_success
      end.should change(Order, :count)

      post_via_redirect(orders_checkout_path, { :checkout => 1, :use_billing_for_shipping => "1", :billing_address => addresses(:adrian).attributes }, { "HTTP_REFERER" => "/orders/checkout" } )
      response.should be_success, response.body
      response.should render_template("billing")
      response.body.should match(/PayPal/)

      # for security, integrated payments should be inaccessible
      get "integrated_payment/billing"
      assert_response :redirect
    end

    it "should choose to pay with a credit card and send a receipt" do
      Forge::Settings[:integrated_payments] = true
      Forge::Settings[:email_receipt] = true

      # add an item to the cart
      product = products(:book_of_bad_puns)
      lambda do
        post_via_redirect(add_to_cart_orders_path, { :product_id => product.id, :quantity => 2}, { "HTTP_REFERER" => "/products/#{product.id}" } )
        response.should be_success
      end.should change(Order, :count)

      post_via_redirect(orders_checkout_path, { :checkout => 1, :use_billing_for_shipping => "1", :billing_address => addresses(:adrian).attributes }, { "HTTP_REFERER" => "/orders/checkout" } )
      response.should be_success, response.body
      response.should render_template("billing")
      response.body.should match(/credit card/)
      
      # for security, hosted payments should be inaccessible
      get "hosted_payment/billing"
      assert_response :redirect

      lambda do
        post_via_redirect("integrated_payment/pay", { :credit_card => { :number => "1", :verification_value => "1" }, :date => { :month => "3", :year => "2015" } })
        response.should be_success, response.body
        response.should render_template("paid")
      end.should change(ActionMailer::Base.deliveries, :size)

      receipt_email = ActionMailer::Base.deliveries.last
      receipt_email.subject.should match(/receipt/i)
    end

  end


end
