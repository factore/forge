class Forge::VideosController < ForgeController
  load_and_authorize_resource :except => [:encode_notify]
  before_filter :get_s3, :only => [:new, :edit, :update, :create]
  before_filter :uses_ckeditor, :only => [:new, :edit, :update, :create]
  skip_before_filter :require_admin, :only => [:encode_notify]

  def index
    respond_to do |format|
      format.html { @videos = Video.paginate(:per_page => 10, :page => params[:page]) }
      format.js {
        @videos = Video.where("title LIKE ?", "%#{params[:q]}%")
        render :partial => "video", :collection => @videos
      }
    end
  end

  def new
    @video = Video.new
  end

  def edit
  end

  def create
    @video = Video.new(params[:video])
    if @video.save
      flash[:notice] = 'Video was successfully created.'
      redirect_to(forge_videos_path)
    else
      render :action => "new"
    end
  end

  def update
    @video.thumbnail = nil if params[:remove_asset] == "1"
    @video.video = nil if params[:remove_video]

    if @video.update_attributes(params[:video])
      flash[:notice] = 'Video was successfully updated.'
      redirect_to(forge_videos_path)
    else
      render :action => "edit"
    end
  end

  def destroy
    @video.destroy
    redirect_to(forge_videos_path)
  end

  def play
    respond_to do |format|
      format.js {
        # need to set the response headers so fancy box recognizes this as HTML
        response.headers["Content-Type"] = 'text/html'
        render :partial => "play", :locals => {:video => @video}
      }
    end
  end

  def encode
    response = @video.encode(Rails.env)
    if response.success?
      flash[:notice] = "Video has been queued for encoding."
    else
      flash[:warning] = "There was an error queueing that video for encoding:<br /><br />".html_safe
      flash[:warning] += response.body["errors"].map { |e| e.titleize }.join('<br />').html_safe
    end
    redirect_to forge_videos_path
  end

  def encode_notify
    @video = Video.find_by_job_id!(params[:job][:id].to_i)
    @video.encode_notify(params[:output])
    render :text => "Success"
  end

  private
    def get_s3
      @s3_direct_upload = S3DirectUpload.new
    end

end
