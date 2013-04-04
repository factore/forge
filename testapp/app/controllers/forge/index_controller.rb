class Forge::IndexController < ForgeController
  def index
    @warnings = []
    @warnings << "You haven't entered a title. &nbsp;<small><a href='/forge/settings'>[Correct This]</a></small>".html_safe if MySettings.site_title.blank?
    @warnings << "You haven't entered a URL. &nbsp;<small><a href='/forge/settings'>[Correct This]</a></small>".html_safe if MySettings.site_url.blank?
    @warnings << "You haven't entered an email address to receive contact messages. &nbsp;<small><a href='/forge/settings'>[Correct This]</a></small>".html_safe  if MySettings.contact_email.blank?
    @warnings << "You haven't entered an email address from which to send contact messages and other site notices. &nbsp;<small><a href='/forge/settings'>[Correct This]</a></small>".html_safe  if MySettings.from_email.blank?
    @warnings << "You haven't entered an email address from which to send dispatches. &nbsp;<small><a href='/forge/settings'>[Correct This]</a></small>".html_safe if MySettings.dispatch_email.blank? && @menu_items.include?("dispatches")
    @warnings << "You haven't entered the Google Analytics code. &nbsp;<small><a href='/forge/settings'>[Correct This]</a></small>".html_safe if MySettings.google_analytics.blank?
    @warnings << "You haven't entered an email address from which to send order receipts. &nbsp;<small><a href='/forge/settings'>[Correct This]</a></small>".html_safe if MySettings.receipt_email.blank? && @menu_items.include?("products")
    
    favicon = File.join(Rails.root, 'public', 'favicon.ico')
    @warnings << "You have not included a custom favicon." if !File.exist?(favicon) || File.read(favicon).size == 0
  end
end
