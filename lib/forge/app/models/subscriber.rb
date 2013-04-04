class Subscriber < ActiveRecord::Base
  validates :email, :presence => true, :uniqueness => true
  has_many :subscriber_group_members
  has_many :groups, :through => :subscriber_group_members, :class_name => "SubscriberGroup" 
end
