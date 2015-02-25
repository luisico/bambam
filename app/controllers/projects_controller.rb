class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  respond_to :html, only: [:index, :show]
  respond_to :js, :json, only: [:new, :create, :edit, :update]

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
    # TODO: move to projects_users controller? And keep here only basic project changes (ie: name)
    # TODO: blank users should give an error?
    if params['project']['user_ids']
      params['project']['user_ids'] = [] if params['project']['user_ids'].blank?
      params['project']['user_ids'] << @project.owner.id unless params['project']['user_ids'].include?(@project.owner.id)
    end

    respond_to do |format|
      @project.update(update_params)
      format.js
      format.json { respond_with_bip(@project) }
    end
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
