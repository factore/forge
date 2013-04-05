class VideoAbility
  include CanCan::Ability
  def initialize(u)
    if u.is_contributor?
      can([:create, :play], Video)
      can([:update, :destroy, :edit], Video) do |item|
        u.id == item.creator_id
      end
    end
  end
end