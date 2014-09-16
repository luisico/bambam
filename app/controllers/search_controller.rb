class SearchController < ApplicationController
  before_filter :authenticate_user!

  def search
    @q = params[:q]
    @groups   = Group.accessible_by(current_ability).search(name_cont: @q).result
    @tracks   = Track.accessible_by(current_ability).search(name_cont: @q).result
    @projects = Project.accessible_by(current_ability).search(name_cont: @q).result
    @users    = User.accessible_by(current_ability).search(email_cont: @q).result
  end

end
