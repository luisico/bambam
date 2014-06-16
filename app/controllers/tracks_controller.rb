class TracksController < ApplicationController
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
    if @track.save
      redirect_to @track, notice: 'Track was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @track.update(track_params)
      redirect_to @track, notice: 'Track was successfully updated.'
    else
     render action: 'edit'
    end
  end

  def destroy
    @track.destroy
    redirect_to tracks_url
  end

  private
  def track_params
    params.require(:track).permit(:name, :path, :project_id)
  end
end
