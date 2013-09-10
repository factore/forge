class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  validates :title, presence: true
  attr_accessible :title

end
