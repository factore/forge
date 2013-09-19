class Forge::ProductsController < ForgeController
  before_filter :uses_ckeditor, :only => [:create, :new, :edit, :update]
  before_filter :get_categories, :except => [:destroy, :reorder]
  load_and_authorize_resource :except => [:edit]

  # TODO: at the moment, only up to 100 products are shown.  This is so that product reordering can work properly
  # (it doesn't work well with pagination).  A better solution needs to be put in place for this.
  def index
    respond_to do |format|
      format.html { @products = Product.limit(100).order("list_order ASC") }
      format.js  {
        params[:q] ||= ''
        @products = Product.where("LOWER(title) LIKE :q OR LOWER(description) LIKE :q", {:q => "%#{params[:q].downcase}%"}).limit(20)
        render :partial => "product_list"
      }
    end
  end

  def search
    params[:search] ||= ''
    @products = Product.find(:all, :order => "title", :conditions => ["LOWER(title) LIKE ? OR LOWER(description) LIKE ?", "%#{params[:search].downcase}%", "%#{params[:search].downcase}%"])
  end

  # GET /forge_products/new
  def new
    @product = Product.new
    @help = HelpTopic.where(:slug => "products_new").first
    if @categories.length == 0
      flash[:notice] = "You need to create at least one category before adding products.  You can do that right here."
      redirect_to forge_product_categories_path
    end
  end

  # GET /forge_products/1/edit
  def edit
    @help = HelpTopic.where(:slug => "products_new").first
    @product = Product.find_with_images(params[:id])
  end

  # DELETE /forge_products/1
  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      flash[:notice] = "Product deleted"
    else
      flash[:warning] = "Product could not be deleted"
    end
    redirect_to(forge_products_url)
  end

  # PUT /forge_products/1
  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product])
      flash[:notice] = 'Your product has been saved.  You can continue making changes, <a href="/forge/products/new">add another one</a>, or <a href="/forge/products">browse the product list</a>.'
      redirect_to edit_forge_product_path(@product)
    else
      flash[:warning] = "There was an error saving your product."
      render :action => "edit"
    end
  end

  # POST /forge_products
  def create
    @product = Product.new(params[:product])
    if @product.save
      flash[:notice] = 'Your product has been added.  You can add images to this product, or go back and <a href="/forge/products/new">add another one</a>.'
      redirect_to edit_forge_product_path(@product)
    else
      render :action => "new"
    end
  end

  def reorder
    list = params[:product_list].map {|id| id.gsub('menu_item_', '')}
    params[:parent_id] ? Product.reorder!(list) : ProductCategory.reorder!(list)
    render :nothing => true
    respond_to do |format|
      format.js { render :status => 200, :text => 'Success' }
    end
  end

  private

    def get_categories
      @categories = ProductCategory.find(:all, :order => "list_order")
    end
end
