class Forge::SubscriberGroupsController < ForgeController
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html {
        @subscriber_groups = SubscriberGroup.paginate(:per_page => 10, :page => params[:page])
        @subscriber_group = SubscriberGroup.new
      }
      format.js {
        @subscriber_groups = SubscriberGroup.where("title LIKE ?", "%#{params[:q]}%")
        render :partial => "subscriber_group", :collection => @subscriber_groups
      }
    end
  end

  def new
    @subscriber_group = SubscriberGroup.new
  end

  def edit
    respond_to do |format|
      format.html {}
      format.js { render :layout => false }
    end
  end

  def create
    @subscriber_group = SubscriberGroup.new(params[:subscriber_group])
    if @subscriber_group.save
      flash[:notice] = 'Subscriber Group was successfully created.'
      redirect_to(forge_subscriber_groups_path)
    else
      render :action => "new"
    end
  end

  def update
    if @subscriber_group.update_attributes(params[:subscriber_group])
      flash[:notice] = 'Subscriber Group was successfully updated.'
      redirect_to(forge_subscriber_groups_path)
    else
      render :action => "edit"
    end
  end

  def destroy
    @subscriber_group.destroy
    redirect_to(forge_subscriber_groups_path)
  end
end
