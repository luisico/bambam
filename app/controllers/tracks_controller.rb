class TracksController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  respond_to :html

  def index
    if current_user.has_role? :admin
      @tracks = Track.all
    else
      @tracks = []
      current_user.projects.each do |project|
        project.tracks.each do |track|
          @tracks << track
        end
      end
    end
  end

  def show
  end

  private
  def track_params
    params.require(:track).permit(:name, :path, :project_id)
  end
end
