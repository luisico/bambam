class TracksController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  respond_to :html

  def index
    if can? :manage, Track
      @tracks = Track.all
    else
      @tracks = Track.includes(project: :projects_users).where(projects_users: {user_id: @current_user}).references(:projects_users)
    end
  end

  def show
  end

  def share
    ShareLink.build_share_link(@track, params[:expires_at])
  end

  private
  def track_params
    params.require(:track).permit(:name, :path, :project_id)
  end
end
