class Forge::EventsController < ForgeController
  load_and_authorize_resource
  before_filter :uses_ckeditor, :only => [:edit, :update, :new, :create]
  

  def index
    respond_to do |format|
      format.html { @events = Event.paginate(:per_page => 10, :page => params[:page]) }
      format.js { 
        @events = Event.where("title LIKE ?", "%#{params[:q]}%")
        render :partial => "event", :collection => @events
      }
    end
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def create
    @event = Event.new(params[:event])
    if @event.save
      flash[:notice] = 'Event was successfully created.'
      redirect_to(forge_events_path)
    else
      render :action => "new"
    end
  end

  def update
    if @event.update_attributes(params[:event])
      flash[:notice] = 'Event was successfully updated.'
      redirect_to(forge_events_path)
    else
      render :action => "edit"
    end
  end

  def destroy
    @event.destroy
    redirect_to(forge_events_path)
  end

end
