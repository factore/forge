class CommentMailer < ActionMailer::Base
  default from: Proc.new { MySettings.from_email }
  
  def comment_notification(email, comment)
    @post = comment.commentable
    @comment = comment
    mail(:to => email, :subject => "#{MySettings.site_name} - New Comment: #{@post.title}")
  end
end
