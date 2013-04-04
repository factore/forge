class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :avatar, :avatar_asset_id, :avatar_asset_url

  has_attached_file :avatar, :styles => {:thumbnail => "120x108#"}
  can_use_asset_for :avatar
  before_avatar_post_process :prevent_pdf_thumbnail

  has_and_belongs_to_many :roles
  has_one :shipping_address, :class_name => "Address"
  has_one :billing_address, :class_name => "Address"

  accepts_nested_attributes_for :shipping_address, :billing_address

  # TODO: change 'Member' to 'Customer'
  # After a user is created, always give them the role of Member
  after_create :apply_member_role

  def apply_member_role
    self.roles << Role.find_by_title("Member") if self.roles.blank?
  end

  # Mass create some is_whatev? convenience methods
  ["Admin", "Super Admin", "Contributor", "Member"].each do |role|
    define_method("is_#{role.dehumanize}?".to_sym) { self.roles.include?(Role.find_by_title(role)) }
  end

  def member?
    is_member?
  end

  def staff?
    is_super_admin? || is_admin? || is_contributor?
  end

  private
   def prevent_pdf_thumbnail
     return false if avatar_file_name.index(".pdf")
   end
end
