class Forge::VideoFeedsController < ForgeController
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html { @videos = VideoFeed.paginate(:per_page => 10, :page => params[:page]) }
      format.js { 
        @videos = VideoFeed.where("title LIKE ?", "%#{params[:q]}%")
        render :partial => "video", :collection => @videos
      }
    end
  end

  def new
    flash[:notice] = VideoFeed.import_videos(MySettings.video_feed_source)
    redirect_to forge_video_feeds_path    
  end

  def edit
    @video = VideoFeed.find(params[:id])
  end

  def create
    @video = VideoFeed.new(params[:video_feed])
    if @video.save
      flash[:notice] = 'VideoFeed was successfully created.'
      redirect_to(forge_video_feeds_path)
    else
      render :action => "new"
    end
  end

  def update
    if @video.update_attributes(params[:video_feed])
      flash[:notice] = 'VideoFeed was successfully updated.'
      redirect_to(forge_video_feeds_path)
    else
      render :action => "edit"
    end
  end

  def publish
    @video.update_attributes(:published => @video.published? ? false : true)
    redirect_to forge_video_feeds_path    
  end

end
