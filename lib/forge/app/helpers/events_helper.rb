module EventsHelper
  def events_calendar_proc
    proc do |time|
      ary = [time.day]

      Event.published.on(time.year, time.month, time.day).each do |e|
        ary << link_to(e.title, url_for(e))
      end

      ary.join("<br/>")
    end
  end
end
