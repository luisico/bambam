class SearchController < ApplicationController
  before_filter :authenticate_user!

  def search
    @q = params[:q]

    projects        = Project.accessible_by(current_ability).search(name_cont: @q).result
    tracks_projects = Project.accessible_by(current_ability).search(tracks_name_cont: @q).result.includes(:tracks)
    @projects       = projects | tracks_projects
    @tracks         = Track.accessible_by(current_ability).search(name_cont: @q).result

    groups          = Group.accessible_by(current_ability).search(name_cont: @q).result
    users_groups    = Group.accessible_by(current_ability).search(members_email_cont: @q).result.includes(:members)
    @groups         = groups | users_groups
    @users          = User.search(email_cont: @q).result
  end
end
