class ProjectsUsersController < ApplicationController
  before_action :authenticate_user!
  authorize_resource

  respond_to :js

  def update
    @projects_user = ProjectsUser.find(params[:id])
    @projects_user.update_attributes!(projects_user_params)
  end

  private

  def projects_user_params
    params.require(:projects_user).permit(:read_only)
  end
end
