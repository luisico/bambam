class SearchController < ApplicationController
  before_filter :authenticate_user!

  def search
    @q = params[:q]
    projects = Project.accessible_by(current_ability).search(name_cont: @q).result
    @tracks   = Track.accessible_by(current_ability).search(name_cont: @q).result
    tracks_projects = []
    @tracks.each {|track| tracks_projects << track.project}.uniq
    @projects = projects | tracks_projects
    groups   = Group.accessible_by(current_ability).search(name_cont: @q).result
    @users    = User.search(email_cont: @q).result
    users_groups = []
    @users.each {|user| users_groups << user.groups }.uniq
    @groups = groups | users_groups.flatten
  end
end
