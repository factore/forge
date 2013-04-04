class Forge::HelpTopicsController < ForgeController

  def index
    @help_topics = HelpTopic.order(:title).group(:title)
    respond_to do |format|
      format.js { render :layout => false }
      format.html { }
    end
  end

  def show
    @help_topic = HelpTopic.where(:slug => params[:slug]).first
    respond_to do |format|
      format.js { render :layout => false }
      format.html { }
    end
  end

  def search
    @page_title = "Searching Help for: #{params[:q]}"
    q = params[:q] ? params[:q] : ""
    @help_topics = HelpTopic.find_with_ferret(params[:q])
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

end
