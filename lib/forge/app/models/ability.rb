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
      can(:destroy, Page) { |page| page.key.blank? }
    elsif u.is_contributor?
      can([:update, :edit], User) { |user| user == u }
      can :read, :all
      can :create, Page
      can([:update, :destroy, :edit], Page) do |item|
        u.id == item.creator_id
      end
      can(:destroy, Page) { |page| page.key.blank? }
    else
      can :read, :all
    end
  end
end