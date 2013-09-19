class EventsController < ApplicationController
  if Forge.config.events.display == :calendar
    helper LaterDude::CalendarHelper
  end

  def index
    @page_title = 'Listing Events'

    if Forge.config.events.display == :calendar
      now = Time.now

      @year = (params[:year] || now.year).to_i
      @month = (params[:month] || now.month).to_i

      template = 'events/index_calendar'
    else
      # this roundabout sorting is necessary because ruby 1.8
      # doesn't preserve insertion order - sorting and then using
      # group_by doesn't guarantee the items will remain in that order
      @events = Event\
        .published\
        .order('starts_at DESC')\
        .group_by { |e| e.starts_at.strftime('%Y/%m') }\
        .sort_by(&:first)\
        .reverse

      template = 'events/index_list'
    end

    respond_to do |format|
      format.html { render :template => template }
      format.mobile { render :template => 'mobile/events' }
    end
  end

  def show
    @event = Event.find_by_id!(params[:id])
    @page_title = @event.title

    respond_to do |format|
      format.html
      format.mobile { render :template => 'mobile/event' }
    end
  end

  def preview
    @event = Event.new(params[:event])
    # call the private methods that cause the timestamps to be set properly
    @event.send(:set_starts_at)
    @event.send(:set_ends_at)
    unless @event.published?
      flash.now[:warning] = "This event is not yet published and will not appear on your live website."
    end
    render :action => :show
  end
end
