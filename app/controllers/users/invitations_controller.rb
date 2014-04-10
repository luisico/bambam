class Users::InvitationsController < Devise::InvitationsController

  private
  def invite_resource
    resource_class.invite!(invite_params, current_inviter) do |u|
      u.add_role(:inviter) if params[:inviter]
    end
  end
end
