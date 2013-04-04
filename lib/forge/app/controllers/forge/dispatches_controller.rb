class Forge::DispatchesController < ForgeController
  load_and_authorize_resource  
  before_filter :uses_ckeditor, :only => [:edit, :new, :update, :create]
  
  def index
    respond_to do |format|
      format.html { @dispatches = Dispatch.paginate(:per_page => 10, :page => params[:page]) }
      format.js { 
        @dispatches = Dispatch.where("title LIKE ?", "%#{params[:q]}%")
        render :partial => "dispatch", :collection => @dispatches
      }
    end
  end

  def new
    @dispatch = Dispatch.new
  end

  def edit
  end
  
  def show
    @dispatch = Dispatch.find(params[:id], :include => [:messages, :queued_messages, :opens, :sent_messages, :failed_messages])
  end
  
  def chart_data
    render :json => @dispatch.chart_data
  end
  
  def opens
    @opens = @dispatch.opens.paginate(:per_page => 15, :page => params[:page])
  end
  
  def clicks
    @clicks = DispatchLinkClick.includes(:dispatch_link).where("dispatch_links.dispatch_id = ?", @dispatch.id).paginate(:per_page => 15, :page => params[:page])
  end    
  
  def unsubscribes
    @unsubscribes = @dispatch.unsubscribes.paginate(:per_page => 15, :page => params[:page])
  end
  
  def create
    @dispatch = Dispatch.new(params[:dispatch])
    if @dispatch.save
      flash[:notice] = 'Dispatch was successfully created.'
      redirect_to(forge_dispatches_path)
    else
      render :action => "new"
    end
  end

  def update
    if @dispatch.update_attributes(params[:dispatch])
      flash[:notice] = 'Dispatch was successfully updated.'
      redirect_to(forge_dispatches_path)
    else
      render :action => "edit"
    end
  end

  def destroy
    @dispatch.destroy
    redirect_to(forge_dispatches_path)
  end
  
  def queue
    @groups = SubscriberGroup.all
    @total_subscribers = Subscriber.count
  end
  
  def test_send
    DispatchMailer.dispatch(@dispatch, params[:test_send_email], "Admin", current_user.id).deliver
    flash[:notice] = "A copy of the dispatch was sent to #{params[:test_send_email]}."
    redirect_to queue_forge_dispatch_path(@dispatch)
  end
  
  def send_all
    if params[:group_send] && params[:group_ids].blank?
      flash[:warning] = "You must select the groups to send the dispatch to."
      redirect_to queue_forge_dispatch_path(@dispatch)
    else
      @dispatch.deliver!(params[:group_ids])
      flash[:notice] = "Your dispatch is currently sending."
      redirect_to forge_dispatches_path
    end
  end

  private
    def get_dispatch
      @dispatch = Dispatch.find(params[:id])
    end
end
