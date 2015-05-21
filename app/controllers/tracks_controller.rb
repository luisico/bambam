class TracksController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  respond_to :html, only: [:index, :show]
  respond_to :json, only: [:create, :update]

  def index
  end

  def show
  end

  def create
    @track.owner = current_user
    if @track.save
      render json: {track: {id: @track.id, name: @track.name, igv: view_context.link_to_igv(@track)}}, status: 200
    else
      render json: {status: :error, message: 'file system error'}, status: 400
    end
  end

  def update
    @track = Track.find(params[:id])

    if track_params[:name]
      @track.update(track_params)
      respond_with_bip(@track)
    else
      if @track.update(track_params)
        render json: {status: :success, message: 'OK' }, status: 200
      else
        render json: {status: :error, message: 'Record not saved'}, status: 400
      end
    end
  end

  def destroy
    respond_to do |format|
      if @track.destroy
        flash[:notice] = 'Track was successfully deleted.'
        format.json { render json: {status: :success, message: 'OK' }, status: 200 }
        format.html { redirect_to project_path(@track.project) }
      else
        format.json {render json: {status: :error, message: 'file system error'}, status: 400}
        format.html { redirect_to projects_path }
      end
    end
  end

  private

  def track_params
    params.require(:track).permit(:name, :path, :owner_id, :projects_datapath_id)
  end
end
