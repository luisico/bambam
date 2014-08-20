class ShareLinksController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource

  respond_to :js

  def new
    @share_link = ShareLink.new(share_link_params)
  end

  def create
    @share_link = ShareLink.new(share_link_params)
    @share_link.access_token = SecureRandom.hex
    @share_link.save
  end

  def update
    @share_link.update(share_link_params)
  end

  def destroy
    @share_link = ShareLink.destroy(params[:id])
  end

  private

  def convert_datepicker_time(time)
    Date.strptime(time, "%m/%d/%Y").strftime("%d/%m/%Y")
  end

  def share_link_params
    params.require(:share_link).permit(:access_token, :expires_at, :track_id, :notes)
  end
end
