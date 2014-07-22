class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  respond_to :html

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if params[:project]
      authorize! :manage, @project if admin_project_params
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
  def admin_project_params
    if params[:project][:name]
      true
    elsif params[:project][:user_ids]
      true
    elsif params[:project][:tracks_attributes]
      if params[:project][:tracks_attributes].map {|k, v| v[:project_id]}.any?
        true
      else
        false
      end
    end
  end

  def project_params
    params.require(:project).permit(:name, :owner_id, :user_ids => [], :tracks_attributes => [:id, :name, :path, :project_id, :_destroy])
  end
end
