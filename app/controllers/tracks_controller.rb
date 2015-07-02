class TracksController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  skip_authorize_resource only: :update

  respond_to :html, only: [:index, :show]
  respond_to :js, only: [:index]
  respond_to :json, only: [:create, :update]

  def index
    @filter = params[:filter]
    tracks = Track.accessible_by(current_ability).
      search(name_or_path_or_genome_or_owner_email_or_owner_first_name_or_owner_last_name_cont: @filter).
      result(distinct: true).order('tracks.id ASC')
    project_tracks = Project.accessible_by(current_ability).
      search(name_cont: @filter).result(distinct: true).
      collect {|project| project.tracks }.flatten
    @tracks = (tracks | project_tracks)
  end

  def show
  end

  def create
    @track.owner = current_user
    if @track.save
      render json: {track: {id: @track.id, name: @track.name, genome: @track.genome, igv: view_context.link_to_igv(@track)}}, status: 200
    else
      render json: {status: :error, message: error_messages(@track, "Record not created") }, status: 400
    end
  end

  def update
    if track_params[:name] || track_params[:genome]
      authorize! :update, @track
      @track.update(track_params)
      respond_with_bip(@track)
    else
      projects_datapath = ProjectsDatapath.find_by_id(track_params[:projects_datapath_id]) if track_params[:projects_datapath_id]
      project = projects_datapath.try(:project)
      authorize! :manage, project
      if @track.update(track_params)
        render json: {status: :success, message: 'OK' }, status: 200
      else
        render json: {status: :error, message: error_messages(@track, "Record not updated")}, status: 400
      end
    end
  end

  def destroy
    respond_to do |format|
      if @track.destroy
        format.json { render json: {status: :success, message: 'OK' }, status: 200 }
        format.html do
          flash[:notice] = 'Track was successfully deleted.'
          redirect_to project_path(@track.project)
        end
      else
        format.json {render json: {status: :error, message: error_messages(@track, "Record not deleted")}, status: 400}
        format.html { redirect_to projects_path }
      end
    end
  end

  private

  def track_params
    params.require(:track).permit(:name, :path, :owner_id, :projects_datapath_id, :genome)
  end

  def error_messages(track, default)
    errors = track.errors.full_messages.join('; ')
    errors.empty? ? default : errors
  end
end
