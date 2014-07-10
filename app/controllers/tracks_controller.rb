class TracksController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  respond_to :html

  def index
    #TODO maybe pull this into a scope
    if can? :manage, Track
      @tracks = Track.all
    else
      #TODO replace this with single ActiveRecord statement using includes
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
