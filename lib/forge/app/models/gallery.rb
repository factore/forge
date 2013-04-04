class Gallery < ActiveRecord::Base
  include Forge::Reorderable
  has_many :photos
  accepts_nested_attributes_for :photos, :allow_destroy => true, :reject_if => lambda { |p| p[:file_asset_id].blank? && p[:id].blank? }
  validates_presence_of :title
  validates_uniqueness_of :title
  default_scope :order => 'galleries.list_order'
  
  def self.find_with_photos(id)
    includes(:photos).order('photos.list_order').find(id)
  end
end
