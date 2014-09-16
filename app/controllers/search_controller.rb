class SearchController < ApplicationController
  before_filter :authenticate_user!

  def search
    @q = params[:q]
    @groups   = Group.search(name_cont: @q).result
    @tracks   = Track.search(name_cont: @q).result
    @projects = Project.search(name_cont: @q).result
    @users    = User.search(email_cont: @q).result
  end

end
