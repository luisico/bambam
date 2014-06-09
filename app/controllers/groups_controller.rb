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

  def edit
  end

  def create
    if @group.save
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @group.update(group_params)
      redirect_to @group, notice: 'Group was successfully updated.'
    else
     render action: 'edit'
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_url
  end

  private
  def group_params
    params.require(:group).permit(:name, :owner_id, :member_ids => [])
  end
end
