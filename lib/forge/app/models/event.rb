class Event < ActiveRecord::Base
  # Scopes, attachments, etc.
  scope :published, where(:published => true)
  scope :upcoming, lambda { { :where => ["ends_at > ?", Time.now], :order => "starts_at" } }
  scope :past, lambda { { :where => ["ends_at < ?", Time.now], :order => "starts_at" } }

  attr_accessor :starts_at_date, :starts_at_time, :ends_at_date, :ends_at_time
  before_save :set_starts_at, :set_ends_at


  # Validations
  validates_presence_of :title
  validates_presence_of :location
  validates_presence_of :description
  validates_format_of :starts_at_time, :with => /\d{1,2}:\d{2}[AaPp][Mm]/i, :message => "must be a valid 12-hour time.", :allow_nil => true
  validates_format_of :starts_at_date, :with => /\d{4}\-\d{1,2}\-\d{2}/, :message => "must match format of YYYY-MM-DD", :allow_nil => true
  validates_format_of :ends_at_time, :with => /\d{1,2}:\d{2}[AaPp][Mm]/i, :message => "must be a valid 12-hour time.", :allow_nil => true
  validates_format_of :ends_at_date, :with => /\d{4}\-\d{1,2}\-\d{2}/, :message => "must match format of YYYY-MM-DD", :allow_nil => true

  def self.on(year, month=nil, day=nil)
    time = Time.mktime(year, month, day)
    delta = day ? 1.day : month ? 1.month : year ? 1.year : fail
    limit = time + delta

    where('starts_at > ? AND starts_at < ?', time, limit).order('starts_at')
  end

  # Relationships

  def display_date
    if starts_at_date == ends_at_date
      "#{starts_at.strftime('%B %d, %Y')} from #{starts_at.strftime('%I:%M%p')} until #{ends_at.strftime('%I:%M%p')}"
    else
      "#{starts_at.strftime("%B %d, %Y at %I:%M%p")} until #{ends_at.strftime("%B %d, %Y at %I:%M%p")}"
    end
  end

  def next
    Event.published.where('starts_at > ?', starts_at).first
  end

  def previous
    Event.published.where('starts_at < ?', starts_at).last
  end

  private
    def set_starts_at
      starts_at_date && starts_at_time && self.starts_at = "#{self.starts_at_date} #{self.starts_at_time}"
    end

    def set_ends_at
      ends_at_date && ends_at_time && self.ends_at = "#{self.ends_at_date} #{self.ends_at_time}"
    end
end
