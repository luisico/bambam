class GroupsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  respond_to :html

  def index
  end

  def show
  end

  def new
  end

  def create
    if @group.save
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render action: 'new'
    end
  end

  private
  def group_params
    params.require(:group).permit(:name, :user_id, :user_ids => [])
  end
end
