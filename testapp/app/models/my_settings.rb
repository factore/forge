class MySettings < RailsSettings::Settings
  def self.full_url
    self.site_url.match("http://").blank? ? "http://#{self.site_url}" : self.site_url
  end
end