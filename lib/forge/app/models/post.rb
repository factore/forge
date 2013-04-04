class Post < ActiveRecord::Base
  # Scopes, Attachments, etc.
  attr_accessor :created_at_date, :created_at_time
  scope :posted, lambda { where("created_at <= ? AND published = ?", Time.now, true) }
  scope :for_archive, lambda { |year, month| where(Post.for_archive_conditions(year, month)) }
  default_scope :order => "created_at DESC"

  # Relationships
  has_and_belongs_to_many :post_categories
  can_have_comments

  # Validations
  validates_presence_of :title, :content, :excerpt
  validates_format_of :created_at_time, :with => /\d{1,2}:\d{2}[AaPp][Mm]/i, :message => "must be a valid 12-hour time."
  validates_format_of :created_at_date, :with => /\d{4}\-\d{1,2}\-\d{2}/, :message => "must match format of YYYY-MM-DD"

  before_save :set_created_at

  def self.submenu
    "posts"
  end

  def category_list
    self.post_categories.map { |c| "<a href='/posts/#{c.id}/category'>#{c.title}</a>" }.join(', ').html_safe
  end

  # Achive month handling
  def archive_title
    self.created_at.strftime("%B %Y")
  end

  def archive_link
    self.created_at.strftime("/posts/%m/%Y")
  end

  def self.get_archive_months
    posts = self.posted.all
    return posts.map{|p| {:title => p.archive_title, :link => p.archive_link} }.uniq
  end

  # previous and next posts for mobile post nav
  def next
    Post.where("created_at > ?", created_at)[-1]
  end

  def previous
    Post.where("created_at < ?", created_at)[0]
  end

  private
  def set_created_at
    created_at_date && created_at_time && self.created_at = "#{created_at_date} #{created_at_time}"
  end

end
