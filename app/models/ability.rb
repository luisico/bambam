class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    alias_action :create, :index, :show, :to => :invite

    if user.has_role? :admin
      can :manage, User
      can :manage, Track
      can :manage, Group
    elsif user.has_role? :inviter
      can :invite, User
      can :cancel, User, id: user.id
      can :manage, Track
      can :manage, Group, user_id: user.id
      can :read, Group
    else
      can :show, User, id: user.id
      can :cancel, User, id: user.id
      can :manage, Track
      can :manage, Group, user_id: user.id
      can :read, Group
    end
  end
end
