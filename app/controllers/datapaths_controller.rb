class DatapathsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @datapath = Datapath.new
  end

  def create
    @datapath = Datapath.new(datapath_params)
    @datapath.save
  end

  private

  def datapath_params
    params.require(:datapath).permit(:path, :user_ids => [])
  end
end
