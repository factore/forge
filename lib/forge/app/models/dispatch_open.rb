class DispatchOpen < ActiveRecord::Base
  default_scope { order("created_at DESC") }

  # open up everything for mass assignment
  attr_protected

end
