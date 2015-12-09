class ProjectsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  respond_to :html, only: [:index, :show]
  respond_to :js, :json, only: [:new, :create, :edit, :update, :index]

  def index
    @filter = params[:filter]
    @projects = Project.accessible_by(current_ability).
      search(name_or_description_or_owner_email_or_owner_first_name_or_owner_last_name_cont: @filter).
      result(distinct: true).order('projects.id ASC')
  end

  def show
    @project = Project.includes(:projects_users, :users).find(params[:id])
    @locus = locus_for(current_user)
  end

  def new
    @project = Project.new(owner: current_user)
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
    params.require(:project).permit(:name, :description).merge(owner_id: current_user.id)
  end

  def update_params
    params.require(:project).permit(:name, :description, user_ids: [])
  end

  def locus_for(user)
    Locus.find_by(locusable_id: @project.id, locusable_type: 'Project', user: user) || Locus.create(locusable_id: @project.id, locusable_type: 'Project', user: user, range: '0')
  end
end
