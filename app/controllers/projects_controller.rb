class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  respond_to :html, only: [:index, :show]
  respond_to :js, only: [:new, :create, :edit, :update]

  def index
  end

  def show
    @project = Project.includes(:projects_users, :users).find(params[:id])
  end

  def new
    @project = Project.new(owner: current_user, users: [current_user])
  end

  def edit
  end

  def create
    @project.save
  end

  def update
    if users = params['project']['user_ids']
      users << @project.owner.id unless users.include?(@project.owner.id)
    end
    @project.update(update_params)
  end

  def destroy
    @project.destroy
    redirect_to projects_url
  end

  private

  def create_params
    params.require(:project).permit(:name).merge(user_ids: [current_user.id], owner_id: current_user.id)
  end

  def update_params
    params.require(:project).permit(:name, user_ids: [])
  end
end
