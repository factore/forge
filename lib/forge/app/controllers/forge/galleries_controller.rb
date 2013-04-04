class Forge::GalleriesController < ForgeController
  load_and_authorize_resource :except => [:edit]
  
  def index
    respond_to do |format|
      format.html { @galleries = Gallery.paginate(:per_page => 10, :page => params[:page]) }
      format.js { 
        @galleries = Gallery.where("title LIKE ?", "%#{params[:q]}%")
        render :partial => "gallery", :collection => @galleries
      }
    end
  end

  def new
    @gallery = Gallery.new
  end

  def edit
    @gallery = Gallery.find_with_photos(params[:id])
  end

  def create
    @gallery = Gallery.new(params[:gallery])
    if @gallery.save
      flash[:notice] = 'Gallery was successfully created.'
      redirect_to(forge_galleries_path)
    else
      render :action => "new"
    end
  end

  def update
    if @gallery.update_attributes(params[:gallery])
      flash[:notice] = 'Gallery was successfully updated.'
      redirect_to(edit_forge_gallery_path(@gallery))
    else
      render :action => "edit"
    end
  end

  def destroy
    @gallery.destroy
    redirect_to(forge_galleries_path)
  end

   
  def reorder
    Gallery.reorder!(params[:gallery_list])
    respond_to do |format|
      format.js { render :nothing => true }
      format.html {flash[:notice] = "Re-ordered successfully" and redirect_to forge_galleries_path }
    end
  end
  
end
