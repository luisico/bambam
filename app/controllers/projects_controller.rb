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
    @project.owner ||= current_user
    @project.users << @project.owner unless @project.users.include?(@project.owner)
    @project.save
  end

  def update
    if params['project']['user_ids']
      params['project']['user_ids'] << @project.owner.id unless params['project']['user_ids'].include?(@project.owner.id)
    end
    @project.update(project_params)
  end

  def destroy
    @project.destroy
    redirect_to projects_url
  end

  private
  def project_params
    params.require(:project).permit(:name, :user_ids => [])
  end
end
