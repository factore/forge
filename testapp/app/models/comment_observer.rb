class CommentObserver < ActiveRecord::Observer
  def after_save(comment)
    # create subscriber
    CommentSubscriber.create(:commentable => comment.commentable, :email => comment.author_email) if comment.subscribe.to_i == 1

    # notify subscribers
    comment.commentable.subscribers.each {|subscriber| CommentMailer.comment_notification(subscriber.email, comment).deliver} if comment.approved?
  end
end
