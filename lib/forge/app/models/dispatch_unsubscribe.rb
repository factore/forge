class DispatchUnsubscribe < ActiveRecord::Base
  belongs_to :dispatch
  validates_presence_of :email
  validates_uniqueness_of :email, :scope => :dispatch_id
end
