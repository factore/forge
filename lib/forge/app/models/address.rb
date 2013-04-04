class Address < ActiveRecord::Base
  has_many :bills, :class_name => 'Order', :foreign_key => "billing_address_id"
  has_many :shipments, :class_name => 'Order', :foreign_key => "shipping_address_id"
  belongs_to :country 
  belongs_to :province

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :address1
  validates_presence_of :city
  # it seems like an address should have a province, but if you have to be able to not enter one for countries where they
  # don't have them / don't have them entered
  # validates_presence_of :province
  validates_presence_of :postal
  validates_presence_of :country_id
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  def self.valid_types
    ['billing', 'shipping']
  end
end
