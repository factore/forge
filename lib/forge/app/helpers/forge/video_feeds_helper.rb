module Forge::VideoFeedsHelper
  def video_feed_embed_in_forge(video)
    if video.source == "youtube"
      "<iframe width='516' height='315' src='https://www.youtube-nocookie.com/embed/#{video.video_id}' frameborder='0' allowfullscreen></iframe>".html_safe 
    elsif video.source == "vimeo"
      "<iframe src='http://player.vimeo.com/video/#{video.video_id}?title=0&amp;byline=0&amp;portrait=0' width='516' height='300' frameborder='0' webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>".html_safe 
    end
  end
end


