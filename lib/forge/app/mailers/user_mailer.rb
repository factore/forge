class UserMailer < ActionMailer::Base
  default :from => MySettings.from_email

  def approved(user)
    @user = user
    subject = "#{MySettings.site_title} :: Account Approved"
    mail(:to => user.email, :subject => subject)
  end
end
