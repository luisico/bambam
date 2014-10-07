class TracksController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  respond_to :html

  def index
  end

  def show
  end

  private
  def track_params
    params.require(:track).permit(:name, :path, :project_id)
  end
end
