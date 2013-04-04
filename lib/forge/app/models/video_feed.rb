class VideoFeed < ActiveRecord::Base
  require 'simple-rss'
  require 'open-uri'

  # Scopes, attachments, etc.
  default_scope :order => "published_at DESC"

  # Validations
  validates_presence_of :video_id, :title, :channel
  validates_uniqueness_of :video_id

  # Relationships


  # Methods
  def self.sources
    ["Youtube","Vimeo"]
  end

  def self.vimeo_types
    ["Channel","Likes"]
  end

  # Video Import
  def self.import_videos(source)
    VideoFeed.build_youtube_feed if source == "Youtube"
    VideoFeed.build_vimeo_feed if source == "Vimeo"
    @response = "A channel has not been set. Check your <a href='/forge/settings?tab=video'>settings</a>.".html_safe if source.blank?

    # Import
    unless @response
      count = 0
      @rss.items.each do |item|
        video = VideoFeed.build_youtube_item(item) if source == "Youtube"
        video = VideoFeed.build_vimeo_item(item) if source == "Vimeo"
        count += 1 if video.save
      end
      @response = "#{count} new videos added."
    end
    @response
  end

  # Youtube Import
  def self.build_youtube_feed
    @response = "A channel has not been set. Check your <a href='/forge/settings?tab=video'>settings</a>.".html_safe if MySettings.youtube_channel.blank?
    begin
      @rss = SimpleRSS.parse open("http://gdata.youtube.com/feeds/api/users/#{MySettings.youtube_channel}/uploads")
    rescue
      @response = "Your channel is not valid. Check your <a href='/forge/settings?tab=video'>settings</a>.".html_safe if @response.blank?
    end
    @rss.blank? ? @response : @rss
  end

  def self.build_youtube_item(item)
    VideoFeed.new(
      :video_id => item.link.split("v=")[1].split("&")[0],
      :title => item.title,
      :channel => MySettings.youtube_channel,
      :thumbnail_url => item.media_thumbnail_url,
      :published_at => item.published,
      :source => item.link.split("://")[1].split("/")[0].gsub("www.", "").split(".")[0]
      )
  end

  # Vimeo Import
  def self.build_vimeo_feed
    @response = "A channel has not been set. Check your <a href='/forge/settings?tab=video'>settings</a>.".html_safe if MySettings.vimeo_channel.blank?
    begin
      @rss = SimpleRSS.parse open("http://vimeo.com/#{MySettings.vimeo_channel}/#{MySettings.vimeo_feed_type == 'Channel' ? 'videos' : MySettings.vimeo_feed_type.downcase}/rss")
    rescue
      @response = "Your channel is not valid. Check your <a href='/forge/settings?tab=video'>settings</a>.".html_safe if @response.blank?
    end
    @rss.blank? ? @response : @rss
  end

  def self.build_vimeo_item(item)
    VideoFeed.new(
      :video_id => item.link.split("vimeo.com/")[1],
      :title => item.title,
      :channel => MySettings.vimeo_channel,
      :thumbnail_url => item.media_thumbnail_url,
      :published_at => item.pubDate,
      :source => item.link.split("://")[1].split(".com")[0]
      )
  end
end