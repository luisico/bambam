class SearchController < ApplicationController
  before_filter :authenticate_user!

  def search
    @q = params[:q]

    @projects_and_tracks = {}
    projects = Project.accessible_by(current_ability).search(name_or_tracks_name_cont: @q).
      result(distinct: true).order('projects.id ASC')
    projects.each { |project| @projects_and_tracks[project] = [] }

    tracks = Track.accessible_by(current_ability).search(name_cont: @q).
      result.order('tracks.project_id ASC')
    tracks.each { |track| @projects_and_tracks[track.project] << track }

    @groups_and_users = {}
    groups = Group.accessible_by(current_ability).search(name_or_members_email_cont: @q).
      result(distinct: true).order('groups.id ASC')

    users = User.search(email_cont: @q).result
    groups.each {|group| @groups_and_users.merge!(group => group.members.select {|member| member if users.include? member})}
  end
end
