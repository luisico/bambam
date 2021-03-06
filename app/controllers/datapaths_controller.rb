class DatapathsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @datapath = Datapath.new
  end

  def new
  end

  def edit
  end

  def create
    @datapath = Datapath.new(datapath_params)
    @datapath.save
  end

  def update
    @datapath.update(datapath_params)
  end

  def destroy
    @datapath = Datapath.destroy(params[:id])
  end

  private

  def datapath_params
    params.require(:datapath).permit(:path, user_ids: [])
  end
end
