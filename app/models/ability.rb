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
      can :manage, ShareLink
      can :update, ProjectsUser
      can :manage, Datapath
      can :manage, ProjectsDatapath
    else

      if user.has_role? :manager
        can :invite, User
        can :manage, Project, owner_id: user.id
        can :manage, Group, owner_id: user.id
        can :manage, Track, :projects_datapath => { :project => { :owner_id => user.id }}
        can :update, ProjectsUser, :project => { :owner_id => user.id }
        can :manage, ProjectsDatapath, :project => { :owner_id => user.id }
      end

      can :show, User, id: user.id
      can :cancel, User, id: user.id

      can :read, Group, :memberships => { :user_id => user.id }

      can :read, Project, :projects_users => { :user_id => user.id }
      can :update_tracks, Project, :projects_users => { :user_id => user.id, read_only: false }

      can :read, Track, :projects_datapath => { :project => { :projects_users => { :user_id => user.id } } }

      can [:update, :destroy], Track do |track|
        projects_users = track.project.projects_users.where(user: user).first
        track.owner == user && !(projects_users.present? && projects_users.read_only)
      end

      can :create, Track do |track|
        track.project.users.include?(user)
      end

      can :manage, ShareLink do |share_link|
        share_link.track.project.users.include?(user)
      end

      can :browser, ProjectsDatapath, :project => { :projects_users => { :user_id => user.id }}

    end
  end
end
