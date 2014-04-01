class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Redirect cancan exceptions to home page and show a flash message
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html {
        redirect_to root_url, alert: exception.message
      }
    end
  end

  protected

  def after_invite_path_for(resource)
    users_path
  end
end
