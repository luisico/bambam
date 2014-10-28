class GroupsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  skip_load_resource only: [:new]

  respond_to :html

  def show
  end

  def new
    @group = Group.new(owner: current_user, members: [current_user])
  end

  def edit
  end

  def create
    @group.owner ||= current_user
    @group.members << @group.owner unless @group.members.include?(@group.owner)
    if @group.save
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if params['group'] && params['group']['member_ids']
      params['group']['member_ids'] << @group.owner.id unless params['group']['member_ids'].include?(@group.owner.id)
    end
    if @group.update(group_params)
      redirect_to @group, notice: 'Group was successfully updated.'
    else
     render action: 'edit'
    end
  end

  def destroy
    @group.destroy
    redirect_to users_path
  end

  private
  def group_params
    params.require(:group).permit(:name, member_ids: [])
  end
end
