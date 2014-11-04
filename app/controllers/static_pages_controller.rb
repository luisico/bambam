class StaticPagesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html

  def help
  end
end
