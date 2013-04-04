class Ability
  include CanCan::Ability

  def initialize(u)
    if u.is_super_admin?
      can :manage, :all
      can :publish, :all
      can :assign_roles, User
    elsif u.is_admin?
      can :manage, :all
      can :publish, :all
      can :assign_roles, User
      # try to stop people from deleting pages that are necessary for their site to run, eg contacts
      can(:destroy, Page) { |page| page.key.blank? }
    elsif u.is_contributor?
      can :create, [Page, Post, Asset, Product, Photo, ProductImage, Subscriber, Video]
      can([:update, :destroy, :edit], [Post, Asset, Product, Photo, ProductImage, Subscriber, Video]) { |item| u.id == item.creator_id }
      can([:update, :edit], [Page])
      can(:destroy, Page) { |page| page.key.blank? }
      can([:update, :edit], User) { |user| user == u }
      can :play, Video
      can :read, :all
    else
      can :read, :all
    end
  end
end
