class Forge::OrdersController < ForgeController
  load_and_authorize_resource

  def index
    conditions = {"fulfill" => '=', "unfulfill" => '<>'}
    unless params[:show].nil?
      @orders = Order.not_pending.where("state #{conditions[params[:show]]} 'fulfilled'").order("created_at DESC") #note that this safe from injection, any params[:show] that isn't "fulfill" or nil will just return false
    else
      @orders = Order.not_pending.order("created_at DESC")
    end
    respond_to do |format|
      format.html { @orders = @orders.paginate(:per_page => 10, :page => params[:page]).includes(:shipping_address, :billing_address) }
      format.js {
        @orders = @orders.where("orders.id = ? OR orders.state = ? OR addresses.first_name LIKE ? OR addresses.last_name LIKE ? OR addresses.email like ?", params[:q], params[:q], "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%").includes(:shipping_address, :billing_address)
        render :partial => "order", :collection => @orders
      }
    end
  end

  def new
    @order = Order.new
  end

  def show
    @order = Order.find(params[:id])
  end

  def edit
  end

  def create
    @order = Order.new(params[:order])
    if @order.save
      flash[:notice] = 'Order was successfully created.'
      redirect_to(forge_orders_path)
    else
      render :action => "new"
    end
  end

  def update
    if @order.update_attributes(params[:order])
      flash[:notice] = 'Order was successfully updated.'
      redirect_to(forge_orders_path)
    else
      render :action => "edit"
    end
  end

  def fulfill
    mark_fulfillment(:action => "fulfill!", :success => "Order marked as fulfilled", :failure => "Error marking as fulfilled")
  end

  def unfulfill
    mark_fulfillment(:action => "unfulfill!", :success => "Order no longer marked as fulfilled.", :failure => "Error marking as unfulfilled")
  end

  def mark_fulfillment(opts = {})
    order = Order.find(params[:id])
    respond_to do |format|
      if order.send(opts[:action])
        format.js { render :nothing => true }
        format.html { flash[:notice] = opts[:success] and redirect_to forge_orders_path }
      else
        format.js { render :status => 500 }
        format.html { flash[:warning] = opts[:failure] and redirect_to forge_orders_path }
      end
    end
  end

  def destroy
    @order.destroy
    redirect_to(forge_orders_path)
  end

  private
    def get_collections
      @billing_addresses = BillingAddress.all
      @shipping_addresses = ShippingAddress.all
    end
end
