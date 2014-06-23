class GroupsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  skip_load_resource only: [:index, :new]

  respond_to :html

  def index
    # Abilities with blocks cannot be magically loaded by cancan
    @groups = Group.all
  end

  def show
  end

  def new
    @group = Group.new(owner: current_user, members: [current_user])
    @potential_members = potential_members(@group)
  end

  def edit
    @potential_members = potential_members(@group)
  end

  def create
    @group.owner ||= current_user
    @group.members << @group.owner unless @group.members.include?(@group.owner)
    if @group.save
      redirect_to @group, notice: 'Group was successfully created.'
    else
      @potential_members = potential_members(@group)
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
    redirect_to groups_url
  end

  private
  def group_params
    params.require(:group).permit(:name, member_ids: [])
  end

  def potential_members(group)
    [group.owner].concat(User.where.not(id: group.owner))
  end
end
