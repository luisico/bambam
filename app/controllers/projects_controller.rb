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
    authorize! :edit_name_and_users, @project if params[:project][:name] || params[:project][:user_ids]
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
     render action: 'edit'
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_url
  end

  private
  def project_params
    params.require(:project).permit(:name, :owner_id, :user_ids => [], :tracks_attributes => [:id, :name, :path, :_destroy])
  end
end
