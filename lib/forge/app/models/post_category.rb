class PostCategory < ActiveRecord::Base
  has_and_belongs_to_many :posts
  validates_uniqueness_of :title

  # open up everything for mass assignment
  attr_protected

end
