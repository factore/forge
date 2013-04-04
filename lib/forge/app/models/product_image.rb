class ProductImage < ActiveRecord::Base
  has_attached_file :image, :styles => {:thumbnail => "120x108#"}
  can_use_asset_for :image
  
  validates_attachment_presence :image
  validates_attachment_content_type :image, :content_type => ['image/gif', 'image/png', 'image/jpeg', 'image/jpg', 'image/pjpeg']
end
