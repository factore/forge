class SubscriberGroup < ActiveRecord::Base
  validates_presence_of :title
  validates_uniqueness_of :title
  has_many :subscriber_group_members, :foreign_key => :group_id
  has_many :subscribers, :through => :subscriber_group_members

  # open up everything for mass assignment
  attr_protected

  def self.subscribers_to_groups(group_ids)
    SubscriberGroup.where(id: group_ids).to_a.map(&:subscribers).flatten.uniq
  end

end
