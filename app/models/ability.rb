class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    alias_action :create, :index, :show, :to => :invite

    if user.has_role? :admin
      can :manage, User
      can :manage, Track
      can :manage, Group
      can :manage, Project
    else
      if user.has_role? :inviter
        can :invite, User
        can :cancel, User, id: user.id
      else
        can :show, User, id: user.id
        can :cancel, User, id: user.id
      end

      can :manage, Track

      can :read, Group do |group|
        group.members.include?(user)
      end

      can :read, Project, :projects_users => { :user_id => user.id }
    end
  end
end
