class SubscriberGroupMember < ActiveRecord::Base
  belongs_to :group, :class_name => "SubscriberGroup", :foreign_key => "group_id"
  belongs_to :subscriber
end
