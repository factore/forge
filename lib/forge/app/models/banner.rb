class Banner < ActiveRecord::Base
  # Scopes, attachments, etc.
  include Forge::Reorderable
  scope :published, where(:published => true)
  has_attached_file :photo, :styles => {:banner => "800x800>", :thumbnail => "120x108#"}, :default_style => :banner
  can_use_asset_for :photo

  # Validations
  validates_presence_of :title
  validates_attachment_presence :photo
end
