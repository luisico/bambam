class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.has_role? :admin
      can :manage, User
    elsif user.has_role? :inviter
      can :manage, User
    else
      can :show, User do |current_user|
        current_user == user
      end
      can :cancel, User do |current_user|
        current_user == user
      end
    end
  end
end
