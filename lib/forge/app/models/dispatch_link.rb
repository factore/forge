class DispatchLink < ActiveRecord::Base
  # Relationships
  belongs_to :dispatch, :foreign_key => :dispatch_id
  has_many :clicks, :class_name => "DispatchLinkClick"
  default_scope :order => "clicks_count DESC"
  
  # Validations
  # validates_presence_of :uri
  # validates_presence_of :dispatch
  # validates_uniqueness_of :position, :scope => :dispatch_id
  
end
