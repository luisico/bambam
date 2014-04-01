class UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  respond_to :html

  def index
    @users = User.order('created_at DESC')
    respond_with(@users)
  end
end
