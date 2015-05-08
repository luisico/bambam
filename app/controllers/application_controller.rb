class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Redirect cancan exceptions to tracks page and show a flash message
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html {
        redirect_to projects_path, alert: exception.message
      }
      format.js {
        render json: {status: :error, message: "You don't have permission to #{exception.action} #{exception.subject.to_s.pluralize}"}, status: 403
      }
    end
  end

  def after_sign_in_path_for(resource)
    projects_path
  end

  protected

  def after_invite_path_for(resource)
    users_path
  end

  def authenticate_inviter!
    authorize!(:create, User) && super
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:invite) << :manager
    devise_parameter_sanitizer.for(:accept_invitation) << [:first_name, :last_name]
  end
end
