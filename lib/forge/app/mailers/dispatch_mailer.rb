class DispatchMailer < ActionMailer::Base
  default from: Proc.new { MySettings.newsletter_email }
  
  def dispatch(dispatch, email, name, subscriber_id)
    @name, @dispatch, @email, @subscriber_id = name, dispatch, email, subscriber_id
    mail(:to => email, :subject => dispatch.subject)
  end
end
