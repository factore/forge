class SubscriberGroup < ActiveRecord::Base
  validates_presence_of :title
  validates_uniqueness_of :title
  has_many :subscriber_group_members, :foreign_key => :group_id
  has_many :subscribers, :through => :subscriber_group_members
end
