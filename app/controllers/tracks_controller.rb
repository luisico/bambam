class TracksController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  respond_to :html

  def index
  end

  def show
  end

  def edit
    @project = @track.project
  end


  def update
    if @track.update(track_params)
      redirect_to @track, notice: 'Track was successfully updated.'
    else
     render action: 'edit'
    end
  end

  def destroy
    project = @track.project
    @track.destroy
    redirect_to project_path(project)
  end

  private
  def track_params
    params.require(:track).permit(:name, :path, :project_id)
  end
end
