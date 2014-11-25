class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    alias_action :create, :index, :show, :to => :invite
    #TODO remove this alias
    alias_action :index, :show, :edit, :update, :to => :user_access

    if user.has_role? :admin
      can :manage, User
      can :manage, Track
      can :manage, Group
      can :manage, Project
      can :manage, ShareLink
    else
      if user.has_role? :inviter
        can :invite, User
        can :cancel, User, id: user.id
      else
        can :show, User, id: user.id
        can :cancel, User, id: user.id
      end

      can :read, Group, :memberships => { :user_id => user.id }

      can :user_access, Project, :projects_users => { :user_id => user.id }

      can :read, Track, Track.user_tracks(user) do |track|
        track.project.users.include?(user)
      end
      can [:update, :destroy], Track, owner: user
      can :create, Track do |track|
        track.project.users.include?(user)
      end

      can :manage, ShareLink do |share_link|
        share_link.track.project.users.include?(user)
      end
    end
  end
end
