class DatapathsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
  end
end
