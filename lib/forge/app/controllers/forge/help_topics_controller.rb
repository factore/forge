class Forge::HelpTopicsController < ForgeController

  def index
    @help_topics = HelpTopic.order(:title).group(:title, :id)
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
    @help_topics = HelpTopic.where(
      "LOWER(content) LIKE :q OR LOWER(title) LIKE :q",
      {:q => q.downcase}
    )
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

end
