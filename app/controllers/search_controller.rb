class SearchController < ApplicationController
  before_action :authenticate_user!

  def search
    @q = params[:q]

    @projects_and_tracks = {}
    projects = Project.accessible_by(current_ability).
      search(name_or_tracks_name_or_tracks_path_cont: @q).
      result(distinct: true).order('projects.id ASC')

    users = User.search(email_or_first_name_or_last_name_cont: @q).result
    users_projects = []
    users.each do |user|
      users_projects << user.projects.select{|p| can? :read, p}
    end

    projects = projects | users_projects.flatten.uniq

    projects.each do |project|
      @projects_and_tracks[project] = { users: [], tracks: [] }
      project.users.each do |user|
        @projects_and_tracks[project][:users] << user if matches_term?(user)
      end
    end

    tracks = Track.accessible_by(current_ability).search(name_or_path_cont: @q).result.
      order('tracks.projects_datapath_id ASC')
    tracks.each { |track| @projects_and_tracks[track.project][:tracks] << track }

    @groups_and_users = {}
    groups = Group.accessible_by(current_ability).search(name_cont: @q).result
    users_groups = []
    users.each do |user|
      users_groups << user.groups.select {|group| can? :read, group}
    end
    groups = groups | users_groups.flatten.uniq
    groups.each {|group| @groups_and_users.merge!(group => group.members.select {|member| member if users.include? member})}
  end

  private

  def matches_term?(user)
    [user.email, user.first_name, user.last_name].join('@@').match(/#{@q}/i).present?
  end
end
