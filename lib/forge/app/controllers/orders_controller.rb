class OrdersController < ApplicationController
  protect_from_forgery :except => [:notify, :paid, :cancel]
  before_filter :get_cart_order

  def add_to_cart
    unless @cart_order
      new_cart_order
    end
    product = Product.find(params[:product_id])
    if params[:quantity].to_i > 0 && @cart_order.add(product, params[:quantity])
      respond_to do |format|
        message = "#{product.title} was added to your cart."
        format.html { flash[:notice] = message and redirect_to :back }
        format.json { render :json => {:status => "Success", :message => message} }
      end
    else
      respond_to do |format|
        message = "There as a problem adding #{product.title} to your cart. Ensure you specified a quantity."
        format.html { flash[:warning] = message and redirect_to :back }
        format.json { render :json => {:status => "Failure", :message => message }}
      end
    end
  end

  def remove_from_cart
    line_item = @cart_order.line_items.find(params[:line_item_id])
    line_item.destroy
    respond_to do |format|
      format.html { flash[:notice] = "#{line_item.product.title} was removed from your cart." and redirect_to :back }
      # TODO: format.js
      format.js { }
    end
  end

  # updates all items in the cart - called via regular, non-AJAX actions including checkout
  def update
    @cart_order.attributes = params[:order]
    # TODO: anything necessary for coupon application - perhaps this can go in the model
    if @cart_order.save
      flash[:notice] = "Your cart was updated successfully."
      if params[:checkout]
        redirect_to_payment
      else
        redirect_to :back
      end
    else
      flash[:warning] = "There was a problem updating your cart." and redirect_to :back
    end
  end

  # updates a single line item - only called via AJAX
  # renders a cart total
  def update_line_item

  end

  # get_cart - for ajaxy-ness
  def get_cart
    render :partial => "cart", :locals => {:order => @cart_order}
  end

  def checkout_get
    @billing_address = @cart_order.billing_address || Address.new
    @shipping_address = @cart_order.shipping_address || Address.new
    @use_billing_for_shipping = (@cart_order.billing_address == @cart_order.shipping_address)
    render :template => "orders/checkout"
  end

  def checkout_post
    load_and_save_address("billing_address")
    if (params[:use_billing_for_shipping] == "1")
      @shipping_address = @billing_address
      @cart_order.shipping_address = @shipping_address
      @cart_order.save
    else
      load_and_save_address("shipping_address")
    end

    if @billing_address.valid? && @shipping_address.valid?
      redirect_to_payment
    else
      render :template => "orders/checkout"
    end

  end

  def paid
    @order = Order.find(params[:id])
    if params[:key] && params[:key] == @order.key
      @page_title = "Thank You"
      new_cart_order
    else
      flash[:warning] = "You are not authorized to view this page."
      redirect_to "/" and return false
    end
  end

  def cancel
    @page_title = "Cancelled"
    new_cart_order
  end

private

  def load_and_save_address(address_name)
    if @cart_order.send address_name.to_sym
      address = @cart_order.send address_name.to_sym
      address.update_attributes(params[(address_name.to_sym)])
    else
      address = Address.new(params[(address_name.to_sym)])
    end

    if address.save
      @cart_order.send((address_name + "=").to_sym, address)
      @cart_order.save
    end

    eval "@#{address_name} = address"
  end

  def redirect_to_payment
    if Forge::Settings[:integrated_payments]
      redirect_to integrated_payment_billing_path
    else
      redirect_to hosted_payment_billing_path
    end
  end

  def new_cart_order
    @cart_order = Order.new
    cookies[:order_key] = { :value => @cart_order.create_key!, :httponly => true }
  end

end
