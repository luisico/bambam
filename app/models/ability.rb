class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.has_role? :admin
      can :manage, User

    elsif user.has_role? :inviter
      can :manage, User

    else
      can :show, User, id: user.id
      can :cancel, User, id: user.id
    end
  end
end
