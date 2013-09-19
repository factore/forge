class Forge::SalesController < ForgeController
  load_and_authorize_resource
  before_filter :uses_ckeditor, :only => [:edit, :update, :new, :create]
  before_filter :set_submenu


  def index
    respond_to do |format|
      format.html { @sales = Sale.paginate(:per_page => 10, :page => params[:page]) }
      format.js {
        params[:q] ||= ''
        @sales = Sale.where("LOWER(title) LIKE ?", "%#{params[:q].downcase}%")
        render :partial => "sale", :collection => @sales
      }
    end
  end

  def new
    @sale = Sale.new
    params[:q] ||= ''
    @products = Product.where("title LIKE :q OR description LIKE :q", {:q => "%#{params[:q].downcase}%"})
  end

  def edit
    params[:q] ||= ''
    @products = Product.where("title LIKE :q OR description LIKE :q", {:q => "%#{params[:q].downcase}%"})
  end

  def create
    @sale = Sale.new(params[:sale])
    if @sale.save
      flash[:notice] = 'Sale was successfully created.'
      redirect_to(forge_sales_path)
    else
      render :action => "new"
    end
  end

  def update
    params[:sale][:product_ids] = params[:sale][:product_ids].split(',')

    if @sale.update_attributes(params[:sale])
      flash[:notice] = 'Sale was successfully updated.'
      redirect_to(forge_sales_path)
    else
      render :action => "edit"
    end
  end

  def destroy
    @sale.destroy
    redirect_to(forge_sales_path)
  end

  def products
    respond_to do |format|
      format.html { @products = Product.all }
      format.js  {
        params[:q] ||= ''
        @products = Product.where("LOWER(title) LIKE :q OR LOWER(description) LIKE :q", {:q => "%#{params[:q].downcase}%"})
        render :partial => "products"
      }
    end

  end

  private

    def set_submenu
      @submenu = "ecommerce"
    end

end
