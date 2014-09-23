class SearchController < ApplicationController
  before_filter :authenticate_user!

  def search
    @q = params[:q]

    projects        = Project.accessible_by(current_ability).search(name_cont: @q).result
    tracks_projects = Project.accessible_by(current_ability).search(tracks_name_cont: @q).result
    projects        = projects | tracks_projects
    tracks          = Track.accessible_by(current_ability).search(name_cont: @q).result
    @projects_and_tracks = {}
    projects.each {|project| @projects_and_tracks.merge!(project => project.tracks.select {|track| track if tracks.include? track})}

    groups          = Group.accessible_by(current_ability).search(name_cont: @q).result
    users_groups    = Group.accessible_by(current_ability).search(members_email_cont: @q).result.includes(:members)
    groups          = groups | users_groups
    users           = User.search(email_cont: @q).result
    @groups_and_users = {}
    groups.each {|group| @groups_and_users.merge!(group => group.members.select {|member| member if users.include? member})}
  end
end
