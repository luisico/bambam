class ShareLinksController < ApplicationController
  before_action :authenticate_user!
  authorize_resource

  respond_to :js

  def new
    @share_link = ShareLink.new(share_link_params.slice(:track_id))
  end

  def edit
    @share_link = ShareLink.find(params[:id])
  end

  def create
    @share_link = ShareLink.new(share_link_params)
    @share_link.access_token = SecureRandom.hex
    @share_link.save
  end

  def update
    @share_link = ShareLink.find(params[:id])
    @share_link.update(share_link_params.slice(:expires_at, :notes))
  end

  def destroy
    @share_link = ShareLink.destroy(params[:id])
  end

  private

  def share_link_params
    params.require(:share_link).permit(:expires_at, :track_id, :notes)
  end
end
