class TracksController < ApplicationController
  before_filter :authenticate_user!

  def index
    @tracks = Track.all
  end

  def show
    @track = Track.find(params[:id])
  end
end
