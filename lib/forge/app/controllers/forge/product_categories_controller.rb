class Forge::ProductCategoriesController < ForgeController
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html {
        @product_categories = ProductCategory.paginate(:per_page => 10, :page => params[:page])
        @product_category = ProductCategory.new
      }
      format.js {
        @product_categories = ProductCategory.where("title LIKE ?", "%#{params[:q]}%")
        render :partial => "product_category", :collection => @product_categories
      }
    end
  end

  def edit
    respond_to do |format|
      format.html {}
      format.js { render :layout => false }
    end
  end

  def create
    @product_category = ProductCategory.new(params[:product_category])
    if @product_category.save
      flash[:notice] = 'Product category was successfully created.'
      redirect_to(forge_product_categories_path)
    else
      render :action => :index
    end
  end

  def update
    if @product_category.update_attributes(params[:product_category])
      flash[:notice] = 'Product category was successfully updated.'
      redirect_to(forge_product_categories_path)
    else
      render :action => "edit"
    end
  end

  def destroy
    @product_category.destroy
    redirect_to(forge_product_categories_path)
  end


  def reorder
    ProductCategory.reorder!(params[:product_category_list])
    respond_to do |format|
      format.js { render :nothing => true }
      format.html { redirect_to :action => :index }
    end
  end
end
