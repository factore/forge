class DispatchLinkClick < ActiveRecord::Base
  belongs_to :dispatch_link, :counter_cache => :clicks_count

  # open up everything for mass assignment
  attr_protected

end
