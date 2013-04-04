class Forge::SubscribersController < ForgeController
  load_and_authorize_resource
  before_filter :get_groups, :only => [:index, :edit, :create, :update]
  before_filter :get_subscribers, :only => [:index, :create]

  def index
    @group = SubscriberGroup.find(params[:group]) unless params[:group].blank?
    respond_to do |format|
      format.html { }
      format.js {
        @subscribers = Subscriber.where("name LIKE :q OR email LIKE :q", {:q => "%#{params[:q]}%"})
        render :partial => "subscriber", :collection => @subscribers
      }
    end
  end

  def new
  end

  def edit
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def create
    @subscriber = Subscriber.new(params[:subscriber])
    if @subscriber.save
      flash[:notice] = 'Subscriber was successfully created.'
      redirect_to(forge_subscribers_path)
    else
      render :action => :index
    end
  end

  def update
    if @subscriber.update_attributes(params[:subscriber])
      flash[:notice] = 'Subscriber was successfully updated.'
      redirect_to(forge_subscribers_path)
    else
      render :action => "edit"
    end
  end

  def destroy
    @subscriber.destroy
    redirect_to(forge_subscribers_path)
  end

  def export
    @subscribers = Subscriber.all
    string = @subscribers.map {|s| "\"#{s.name}\",\"#{s.email}\""}.join("\n")
    send_data string, :filename => "Subscribers-Export-#{Time.now.strftime('%b-%e-%Y')}.csv"
  end

  private
    def get_groups
      @groups = SubscriberGroup.all
    end

    def get_subscribers
      @group = SubscriberGroup.find(params[:group]) unless params[:group].blank?
      @subscribers = @group.blank? ? Subscriber.paginate(:per_page => 10, :page => params[:page]) : @group.subscribers.paginate(:per_page => 10, :page => params[:page])
      @subscriber = Subscriber.new
    end
end
