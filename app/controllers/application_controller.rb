class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?

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

  def after_sign_in_path_for(resource)
    tracks_path
  end

  protected

  def after_invite_path_for(resource)
    users_path
  end

  def authenticate_inviter!
    authorize!(:create, User) && super
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:invite) << :inviter
  end
end
