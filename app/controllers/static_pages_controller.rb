class StaticPagesController < ApplicationController
  before_action :authenticate_user!

  respond_to :html

  def help
  end
end
