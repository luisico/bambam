class TracksController < ApplicationController
  before_filter :authenticate_user!

  def index
    @tracks = Track.all
  end

  def show
    @track = Track.find(params[:id])
  end

  def new
    @track = Track.new
  end

  def create
    @track = Track.new(track_params)

    respond_to do |format|
      if @track.save
        format.html { redirect_to @track, notice: 'Track was successfully created.' }
        format.json { render action: 'show', status: :created, location: @track }
      else
        format.html { render action: 'new' }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def track_params
    params.require(:track).permit(:name, :path)
  end
end
