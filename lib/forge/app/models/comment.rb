class Comment < ActiveRecord::Base
  # TODO: put this back in
  # has_rakismet
  def spam?; false; end

  validates_presence_of :commentable, :author, :author_email, :content
  validates_format_of :author_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  belongs_to :commentable, :polymorphic => true

  attr_protected :approved
  attr_accessor :subscribe, :controller

  default_scope { order("created_at DESC") }
  scope :approved, -> { where(:approved => true).order("created_at ASC") }

  # open up everything for mass assignment
  attr_protected

  # Comment/uncomment this to turn off/on moderation
  # before_save :approve
  
  after_save :handle_subscribers

  def self.create_comment(object, session)
    session.blank? ? Comment.new(:commentable_type => object.class.to_s, :commentable_id => object.id) : Comment.new(session)
  end

  def email
    self.author_email
  end

  def approve!
    self.approved = true
    return self.save
  end

  def unapprove!
    self.approved = false
    return self.save
  end

  def approve
    self.approved = true
  end

  def author_url
    if super.blank? || super.match('http://') || super.match('https://')
      return super
    else
      return 'http://' + super
    end
  end

  def short?
    content.length > 100 ? true : false
  end

  def short_comment
    "#{self.content[0..100]}..."
  end

  def error_message
    errors = []
    self.errors.full_messages.each { |error| errors << "<li>#{error}</li>" }
    return "<div class='errorExplanation' id='errorExplanation'>There were problems with the following fields:<ul>#{errors}<ul></div>"
  end

  private

    def handle_subscribers
      # create subscriber
      CommentSubscriber.create(:commentable => self.commentable, :email => self.author_email) if self.subscribe.to_i == 1

      # notify subscribers
      self.commentable.subscribers.each {|subscriber| CommentMailer.comment_notification(subscriber.email, self).deliver} if self.approved?
    end

end
