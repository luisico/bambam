class GroupsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  skip_load_and_authorize_resource only: :new

  respond_to :html

  def index
  end

  def show
  end

  def new
    @group = Group.new(owner: current_user, members: [current_user])
    authorize! :new, @group
    @potential_members = potential_members(@group)
  end

  def edit
    @potential_members = potential_members(@group)
  end

  def create
    @potential_members = potential_members(@group)
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
    params.require(:group).permit(:name, member_ids: [])
  end

  def potential_members(group)
    [group.owner].concat(User.where.not(id: group.owner.id))
  end
end
