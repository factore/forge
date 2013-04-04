class EventsController < ApplicationController
  caches_page :index, :show

  if Forge::Settings[:events][:display] == 'calendar'
    helper LaterDude::CalendarHelper
  end

  def index
    @page_title = 'Listing Events'

    if Forge::Settings[:events][:display] == 'calendar'
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
end
