class QueuedDispatch < ActiveRecord::Base
  # Relationships
  belongs_to :dispatch
  belongs_to :subscriber
  
  # Scopes
  scope :queued, where('sent_at IS NULL')
  scope :sent, where("sent_at IS NOT NULL")
  scope :failed, where("failed_attempts > ?", 0)
  scope :opened, where("opened_at IS NOT NULL")
  
  # Action Methods
  def send!
    DispatchMailer.dispatch(self.dispatch, self.subscriber.email, self.subscriber.name, self.subscriber.id).deliver
    self.sent_at = Time.now
    self.save
  end
  handle_asynchronously :send!
  
  def self.send_queued!
    self.queued.all.each { |m| m.send! }
  end
  
  def mark_as_opened!
    self.opened_at = Time.now and self.save
  end
  
  # Query Methods
  def sent?
    self.sent_at
  end
  
  def failed?
    self.failed_attempts > 0 && !self.sent?
  end
end
