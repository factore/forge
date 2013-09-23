class QueuedDispatch < ActiveRecord::Base
  # Relationships
  belongs_to :dispatch
  belongs_to :emailable, :polymorphic => true

  # Scopes
  scope :queued, where('sent_at IS NULL')
  scope :sent, where("sent_at IS NOT NULL")
  scope :failed, where("failed_attempts > ?", 0)
  scope :opened, where("opened_at IS NOT NULL")

  attr_protected

  # Action Methods
  def self.send_dispatch_to_object_with_name_and_email!(dispatch, object_with_name_and_email)
    qd = QueuedDispatch.create(:dispatch => dispatch, :emailable_id => object_with_name_and_email.id, :emailable_type => object_with_name_and_email.class.to_s)
    qd.send!
  end

  def send!
    DispatchMailer.dispatch(self.dispatch, self.emailable.email, self.emailable.name).deliver
    self.sent_at = Time.now
    self.save
  end

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
