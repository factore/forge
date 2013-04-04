class DispatchMailer < ActionMailer::Base
  default :from => MySettings.newsletter_email
  default_url_options[:host] = MySettings.site_url ? MySettings.site_url.gsub('http://', '') : 'localhost:3000'
  
  def dispatch(dispatch, email, name, subscriber_id)
    @name, @dispatch, @email, @subscriber_id = name, dispatch, email, subscriber_id
    mail(:to => email, :subject => dispatch.subject)
  end
end
