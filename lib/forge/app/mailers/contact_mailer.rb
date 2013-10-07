class ContactMailer < ActionMailer::Base
  default from: Proc.new { MySettings.from_email }, to: Proc.new { MySettings.contact_email }
  
  def contact(contact)
    @contact = contact
    subject = @contact.subject.blank? ? "#{MySettings.site_title} :: Contact Received" : "#{MySettings.site_title} :: #{@contact.subject}"
    mail(:subject => subject)
  end
end
