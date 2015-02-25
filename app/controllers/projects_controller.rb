class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  respond_to :html, only: [:index, :show]
  respond_to :js, :json, only: [:new, :create, :edit, :update]

  def index
  end

  def show
    @project = Project.includes(:projects_users, :users).find(params[:id])
    @regular_users = @project.regular_users
    @read_only_users = @project.read_only_users
  end

  def new
    @project = Project.new(owner: current_user, users: [current_user])
  end

  def edit
  end

  def create
    @project.owner ||= current_user
    @project.users << @project.owner unless @project.users.include?(@project.owner)
    if @project.save
      render :js => "window.location = '#{project_path(@project)}'"
    end
  end

  def update
    # TODO: move to projects_users controller? And keep here only basic project changes (ie: name)
    if params['project']['user_ids']
      params['project']['user_ids'] << @project.owner.id unless params['project']['user_ids'].include?(@project.owner.id)
    end

    respond_to do |format|
      @project.update(project_params)
      format.js
      format.json { respond_with_bip(@project) }
    end
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
