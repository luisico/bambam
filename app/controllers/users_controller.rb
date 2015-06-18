class UsersController < ApplicationController
  before_action :authenticate_user!, except: :new
  load_and_authorize_resource
  skip_authorize_resource only: :new

  respond_to :html

  def index
    @users = User.order('created_at DESC')
    @groups = Group.accessible_by(current_ability)
    @projects = Project.accessible_by(current_ability)
  end

  def show
    user_ability = Ability.new(@user)
    @projects = Project.accessible_by(user_ability)
  end

  def new
    if current_user
      redirect_to(root_url, notice: 'You already have an account')
    else
      render 'users/registrations/new'
    end
  end

  def cancel
    render 'users/registrations/cancel'
  end
end
