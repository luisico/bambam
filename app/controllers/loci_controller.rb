class LociController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  respond_to :js

  def update
    if @locus.update(locus_params)
      render json: {status: :success, message: 'OK' }, status: 200
    else
      render json: {status: :error, message: "Record not updated"}, status: 422
    end
  end

  private

  def locus_params
    params.require(:locus).permit(:range)
  end
end
