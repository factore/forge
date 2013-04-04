class Forge::PostCategoriesController < ForgeController
  load_and_authorize_resource

  def index
    @post_category = PostCategory.new
    respond_to do |format|
      format.html { get_post_categories }
      format.js {
        @post_categories = PostCategory.where("title LIKE ?", "%#{params[:q]}%")
        @post_categories = @post_categories.order(:title)
        render :partial => "post_category", :collection => @post_categories
      }
    end
  end

  def edit
    respond_to do |format|
      format.js { render :layout => false }
      format.html { }
    end
  end

  def create
    @post_category = PostCategory.new(params[:post_category])
    if @post_category.save
      flash[:notice] = 'Post category was successfully created.'
      redirect_to(forge_post_categories_path)
    else
      get_post_categories
      render :action => "index"
    end
  end

  def update
    if @post_category.update_attributes(params[:post_category])
      flash[:notice] = 'Post category was successfully updated.'
      redirect_to(forge_post_categories_path)
    else
      render :action => "edit"
    end
  end

  def destroy
    @post_category.destroy
    redirect_to(forge_post_categories_path)
  end

  private

    def get_post_categories
      @post_categories = PostCategory.order(:title).paginate(:per_page => 10, :page => params[:page])
    end
end
