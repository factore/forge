class HelpTopic < ActiveRecord::Base
  acts_as_ferret :fields => [ :content ]
  validates_presence_of :language, :slug, :title, :content
  validates_format_of :slug, :with => /\A[a-zA-Z0-9_-]+\z/
  validates_uniqueness_of :slug, :scope => :language
  before_save :convert_content_to_html
  default_scope where(:language => I18n.locale.to_s)

protected

  def convert_content_to_html
    self.content = RDiscount.new(self.content).to_html
  end

end
