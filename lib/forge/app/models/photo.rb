class Photo < ActiveRecord::Base
  belongs_to :gallery, :class_name => "Gallery", :foreign_key => "gallery_id"
  has_attached_file :file, :styles => {:thumbnail => "120x108#", :medium => "800x600>"}
  can_use_asset_for :file
  default_scope :order => :list_order
end
