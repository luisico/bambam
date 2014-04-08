class Users::InvitationsController < Devise::InvitationsController
  def create
    invite_resource.add_role :inviter if params[:inviter]
    super
  end
end
