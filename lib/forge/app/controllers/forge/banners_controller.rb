class Forge::BannersController < ForgeController
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html { @banners = Banner.order(:list_order).paginate(:per_page => 10, :page => params[:page]) }
      format.js {
        @banners = Banner.where("title LIKE ?", "%#{params[:q]}%")
        render :partial => "banner", :collection => @banners
      }
    end
  end

  def new
    @banner = Banner.new
  end

  def edit
  end

  def create
    @banner = Banner.new(params[:banner])
    if @banner.save
      flash[:notice] = 'Banner was successfully created.'
      redirect_to(forge_banners_path)
    else
      render :action => "new"
    end
  end

  def update
    @banner.photo = nil if params[:remove_asset] == "1"
    if @banner.update_attributes(params[:banner])
      flash[:notice] = 'Banner was successfully updated.'
      redirect_to(forge_banners_path)
    else
      render :action => "edit"
    end
  end

  def destroy
    @banner.destroy
    redirect_to(forge_banners_path)
  end


  def reorder
    Banner.reorder!(params[:banner_list])

    respond_to do |format|
      format.js { render :nothing => true }
      format.html {
        flash[:notice] = "Banners reordered!"
        redirect_to :action => :index
      }
    end
  end

end
