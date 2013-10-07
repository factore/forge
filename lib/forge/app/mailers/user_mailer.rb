class UserMailer < ActionMailer::Base
  default from: Proc.new { MySettings.from_email }

  def approved(user)
    @user = user
    subject = "#{MySettings.site_title} :: Account Approved"
    mail(:to => user.email, :subject => subject)
  end
end
