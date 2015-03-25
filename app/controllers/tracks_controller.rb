class TracksController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource

  respond_to :html, only: [:index, :show]
  respond_to :json, only: [:create]

  def index
    @tracks = Track.accessible_by(current_ability)
  end

  def show
    @track = Track.find(params[:id])
  end

  def create
    @track = Track.new(track_params)
    @track.owner = current_user
    if @track.save
      render json: {track: {id: @track.id, name: @track.name, igv: view_context.link_to_igv(@track)}}, status: 200
    else
      message = @track.errors.collect {|name, msg| msg }.join(';')
      render json: {status: :error, message: message}, status: 400
    end
  end

  def destroy
    @track = Track.find_by_id(params[:id])
    authorize! :destroy, @track
    respond_to do |format|
      if @track && @track.destroy
        flash[:notice] = 'Track was successfully deleted.'
        format.json { render json: {status: :success, message: 'OK' }, status: 200 }
        format.html { redirect_to project_path(@track.project) }
      else
        format.json {render json: {status: :error, message: 'file system error'}, status: 400}
      end
    end
  end

  private

  def track_params
    params.require(:track).permit(:name, :path, :owner_id, :projects_datapath_id)
  end
end
