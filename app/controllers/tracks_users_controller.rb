class TracksUsersController < ApplicationController
  before_action :authenticate_user!
  authorize_resource

  respond_to :js

  def create
    tracks_user = TracksUser.new(tracks_user_params)
    tracks_user.user = current_user
    if tracks_user.save
      render json: {status: :success, message: 'OK' }, status: 200
    else
      render json: {status: :error, message: "Record not created" }, status: 400
    end
  end

  def update
    tracks_user = TracksUser.find(params[:id])
    if tracks_user.update(tracks_user_params)
      render json: {status: :success, message: 'OK' }, status: 200
    else
      render json: {status: :error, message: "Record not updated"}, status: 422
    end
  end

  private

  def tracks_user_params
    params.require(:tracks_user).permit(:track_id,  :locus)
  end
end
