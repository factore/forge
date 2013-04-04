class Video < ActiveRecord::Base
  # Scopes, attachments, etc.
  has_attached_file :thumbnail, :styles => {:thumbnail => "120x108#"}, :default_url => ""
  can_use_asset_for :thumbnail
  has_attached_file :video,
    :url => "videos/:basename.:extension",
    :path => "videos/:basename.:extension",
    :storage => :s3,
    :s3_credentials => File.join(Rails.root, 'config', 's3.yml'),
    :default_url => ""

  # Validations
  validates_attachment_presence :video
  validates_presence_of :title
  
  before_update :revert_if_new_upload

  
  def video=(filename)
    self.video_file_name = filename.gsub('videos/', '')
  end
  
  def list_title
    published ? title : title + " (Draft)"
  end
  
  def encoded_state; read_attribute(:encoded_state) || "unencoded"; end
  def mobile_encoded_state; read_attribute(:mobile_encoded_state) || "unencoded"; end
  
  def encode(rails_env)
    test = rails_env == "production" ? false : true
    response = Zencoder::Job.create({
      :api_key => Forge::Settings[:zencoder][:api_key],
      :input => video.url, 
      :outputs => [web_encode_settings, mobile_encode_settings, thumbnail_settings],
      :test => test,
      :skip_ssl_verify => test
    })
    self.update_attributes(:encoded_state => "queued", :mobile_encoded_state => "queued", :job_id => response.body["id"]) if response.success?
    response
  end
  
  def encode_notify(output)
    prefix = output[:label] == "web" ? "" : "#{output[:label]}_"
    attrs = {"#{prefix}encoded_state" => output[:state]}
    if output[:state] == "finished"
      thumb = open(URI.parse("http://s3.amazonaws.com/" + Forge::Settings[:zencoder][:bucket] + "/thumbnails_#{id}/frame_0000.png"))
      attrs.merge!({"#{prefix}output_url" => output[:url]})
      attrs.merge!({"thumbnail" => thumb}) if thumbnail.url.blank?
    end
    self.update_attributes(attrs)
  end
    
  
  private
    def base_url
      "http://s3.amazonaws.com/#{Forge::Settings[:zencoder][:bucket]}"
    end
  
    def web_encode_settings
      { 
        :label => "web",
        :base_url => base_url,
        :size => "800x450",
        :public => 1,
        :notifications => [{:format => "json", :url => "#{MySettings.site_url}/forge/videos/encode_notify"}]
      }
    end
  
    def mobile_encode_settings
      {
        :label => "mobile",
        :base_url => base_url,
        :size => "640x360",
        :public => 1,
        :notifications => [{:format => "json", :url => "#{MySettings.site_url}/forge/videos/encode_notify"}]
      }
    end
  
    def thumbnail_settings
      {
        :thumbnails => {
          :number => 1,
          :public => 1,
          :base_url => base_url + "/thumbnails_#{id}",
          :size => "800x450"
        }
      }
    end
    
    def revert_if_new_upload
      if video_file_name_changed?
        self.output_url = self.mobile_output_url = ''
        self.encoded_state = self.mobile_encoded_state = 'unencoded'
      end
    end
end
