class Forge::AssetsController < ForgeController
  protect_from_forgery :except => [ :create, :encode_notify ]
  skip_before_filter :require_admin, :only => [:create, :encode_notify]
  before_filter :get_asset, :only => [:show, :edit, :update, :destroy, :prepare, :place]

  def new
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def index
    respond_to do |format|
      format.html { @assets = Asset.paginate(:per_page => 20, :page => params[:page]) }
      format.js {
        @assets = Asset.where("assets.title LIKE ?", "%#{params[:q]}%")
        render :partial => "asset", :collection => @assets
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
    @asset = Asset.new(params[:asset])
    @asset.swfupload_file!(params[:Filedata], params[:Filename])

    if @asset.save
      render :json => {:id => @asset.id, :url => @asset.icon_path}
    else
      render :json => {:errors => @asset.errors.full_messages.to_sentence }
    end
  end

  def destroy
    @asset.destroy
    flash[:notice] = "Asset deleted successfully!"
    redirect_to forge_assets_path
  end

  def update
    if @asset.update_attributes(params[:asset])
      flash[:notice] = "Asset updated succesfully."
      redirect_to forge_assets_path
    else
      render :action => :edit
    end
  end

  def show
    respond_to do |format|
      format.js {
        partial = params[:drawer] ? "drawer_asset" : "asset"
        render :status => 200, :partial => partial, :locals => {:asset => @asset}
      }
    end
  end

  ### Methods dealing with the drawer, placing, and setting ###
  def drawer
    @assets = Asset.for_drawer(params)
    respond_to do |format|
      format.js { render :partial => "drawer_asset", :collection => @assets }
    end
  end

  def prepare
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def place
    @options = params[:options]
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

protected

  def get_asset
    @asset = Asset.find(params[:id])
  end
end
