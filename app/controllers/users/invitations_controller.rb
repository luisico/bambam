class Users::InvitationsController < Devise::InvitationsController

  # GET /resource/invitation/new
  def new
    redirect_to users_path
  end

  # POST /resource/invitation
  def create
    self.resource = invite_resource
    if resource.errors.empty?
      yield resource if block_given?
      set_flash_message(:notice, :send_instructions, email: self.resource.email) if self.resource.invitation_sent_at
      respond_with resource, location: after_invite_path_for(resource)
    else
      @users = User.order('created_at DESC')
      @groups = Group.all
      render 'users/index'
    end
  end

  private
  def add_invitee_to_projects(user)
    [params[:project_ids]].flatten.each do |project_id|
      project = Project.where(id: project_id).first
      project.users << user if project.present?
    end
  end

  def invite_resource
    resource_class.invite!(invite_params, current_inviter) do |u|
      u.add_role(:manager) if params[:manager]
      add_invitee_to_projects(u) if params[:project_ids]
    end
  end
end
