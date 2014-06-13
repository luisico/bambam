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

  def create
    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render action: 'new'
    end
  end

  private
  def project_params
    params.require(:project).permit(:name, :owner_id, :user_ids => [], :track_ids => [])
  end
end
