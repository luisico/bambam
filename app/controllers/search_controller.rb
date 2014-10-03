class SearchController < ApplicationController
  before_filter :authenticate_user!

  def search
    @q = params[:q]

    @projects_and_tracks = {}
    projects = Project.accessible_by(current_ability).
      search(name_or_tracks_name_or_tracks_path_cont: @q).
      result(distinct: true).order('projects.id ASC')

    users = User.search(email_cont: @q).result
    users_projects = []
    users.each do |user|
      users_projects << user.projects.select{|p| can? :user_access, p}
    end

    projects = projects | users_projects.flatten.uniq

    projects.each { |project| @projects_and_tracks[project] = { users: [], tracks: [] } }

    projects.each do |project|
      project.users.each do |user|
        @projects_and_tracks[project][:users] << user if user.email.include? @q
      end
    end

    tracks = Track.accessible_by(current_ability).search(name_or_path_cont: @q).
      result.order('tracks.project_id ASC')
    tracks.each { |track| @projects_and_tracks[track.project][:tracks] << track }

    @groups_and_users = {}
    groups = Group.accessible_by(current_ability).search(name_cont: @q).result
    users = User.search(email_cont: @q).result
    users_groups = []
    users.each do |user|
      users_groups << user.groups.select {|group| can? :read, group}
    end
    groups = groups | users_groups.flatten.uniq
    groups.each {|group| @groups_and_users.merge!(group => group.members.select {|member| member if users.include? member})}
  end
end
