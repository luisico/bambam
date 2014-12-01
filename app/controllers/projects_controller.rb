class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  respond_to :html

  def index
  end

  def show
    @project = Project.includes(:projects_users).find(params[:id])
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
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if params[:project]
      authorize! :manage, @project if has_admin_attr?
      if params['project']['user_ids']
        params['project']['user_ids'] << @project.owner.id unless params['project']['user_ids'].include?(@project.owner.id)
      end
      if @project.update(project_params)
        redirect_to @project, notice: 'Project was successfully updated.'
      else
        render action: 'edit'
      end
    else
      redirect_to @project, notice: 'Nothing was changed in the project.'
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_url
  end

  private

  def has_admin_attr?
    params[:project].include?(:name) || params[:project].include?(:user_ids) ||
      (params[:project][:tracks_attributes] &&
      params[:project][:tracks_attributes].map {|k, v| v[:project_id]}.any?)
  end

  def project_params
    params.require(:project).permit(:name, :user_ids => [], :tracks_attributes => [:id, :name, :path, :project_id, :owner_id, :_destroy])
  end
end
