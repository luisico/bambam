### Methods

def build_invitee
  @invitee ||= FactoryGirl.attributes_for(:user)
end

def fill_invitation_form(invitee=nil)
  invitee ||= @invitee
  fill_in User.human_attribute_name(:email), with: invitee[:email]
  yield if block_given?
  click_button I18n.t('devise.invitations.new.submit_button')
end

def sign_up(invitee=nil)
  invitee ||= @invitee
  fill_in 'user_password', with: invitee[:password]
  fill_in 'user_password_confirmation', with: invitee[:password_confirmation]
  yield if block_given?
  click_button I18n.t('devise.invitations.edit.submit_button')
end

### Given

### When

When /^I invite an already registered user$/ do
  registered_user = FactoryGirl.create(:user)
  expect{
    build_invitee
    fill_invitation_form @invitee.merge(email: registered_user.email)
  }.not_to change(User, :count)
end

When /^I invite a user with a blank email$/ do
  expect{
    build_invitee
    fill_invitation_form @invitee.merge(email: '')
  }.not_to change(User, :count)
end

When /^an (admin|inviter) user invites me$/ do |role|
  if role == 'admin'
    @inviter = FactoryGirl.create(:admin)
  else
    @inviter = FactoryGirl.create(:inviter)
  end
    @invitee = @visitor

  expect {
    @user = User.invite!({email: @invitee[:email]}, @inviter)
  }.to change(User, :count).by(1)
end

When /^I click in the accept invitation email link$/ do
  user = User.where(email: @invitee[:email]).first
  visit_in_email accept_user_invitation_path(invitation_token: extract_token_from_email(ActionMailer::Base.deliveries[0], :invitation_token))
end

When /^I am invited$/ do
  step %{I do not exist as a user}
  step %{an admin user invites me}
  step %{I should receive an invitation}
end

When /^I try to invite a user$/ do
  visit new_user_invitation_path
end

When /^I try to used an already expired invitation token$/ do
  find_user
  @user.invitation_created_at = @user.invitation_created_at - 1.year
  @user.save!

  step %{I click in the accept invitation email link}
end

When /^I visit the sign up page$/ do
  visit '/users/sign_up'
end

When /^I visit the cancel account page$/ do
  visit '/users/cancel'
end

Then /^I should( not)? be able to invite a user with(out)? inviter priviledges$/ do |_not, out|
  build_invitee
  if out
    expect {
      fill_invitation_form
    }.to change(User, :count).by(1)
    expect(User.last.has_role?(:inviter)).to eq false
  elsif _not
    expect {
      fill_invitation_form do
        expect(page).not_to have_content('Check to grant inviter priviledges to this user')
      end
    }.to change(User, :count).by(1)
    expect(User.last.has_role?(:inviter)).to eq false
  else
    expect{
      fill_invitation_form do
        check('Check to grant inviter priviledges to this user')
      end
    }.to change(User, :count).by(1)
    expect(User.last.has_role?(:inviter)).to eq true
  end
end

Then /^I should( not)? be able to invite a user and add them to an existing project$/ do |_not|
  if _not
    expect {
      build_invitee
      fill_invitation_form do
        expect(page).not_to have_content('Add invitee to an existing project')
      end
    }.to change(User, :count).by(1)
    expect(@project.users).not_to include User.last
  else
    expect{
      build_invitee
      fill_invitation_form do
        select "#{@project.name}", from: 'Add invitee to an existing project'
      end
    }.to change(User, :count).by(1)
    expect(@project.users).to include User.last
  end
end

Then /^I should see a message confirming that an invitation email has been sent$/ do
  expect(page).to have_css('.alert-box', text: I18n.t("devise.invitations.send_instructions", email: @invitee[:email]))
end

Then /^(I|the invitee) should receive an invitation$/ do |foo|
  open_last_email_for(@invitee[:email])
  expect(current_email.subject).to eq I18n.t('devise.mailer.invitation_instructions.subject')
  expect(current_email.body).to include accept_user_invitation_path(invitation_token: extract_token_from_email(current_email, :invitation_token))
end

Then /^no invitation should have been sent$/ do
  expect(ActionMailer::Base.deliveries).to be_empty
end

Then /^I should be on the invitation page$/ do
  expect(current_path).to eq user_invitation_path
end

Then /^I should be able to activate my invitation$/ do
  find_user
  expect{
    sign_up
    @user.reload
  }.to change(@user, :accepted_or_not_invited?)
end

Then /^I should not be able to sign up with an empty password$/ do
  expect{
    sign_up @invitee.merge(password: '')
    @user.reload
  }.not_to change(@user, :accepted_or_not_invited?)
end

Then /^I should not be able to sign up with an invalid invitation token$/ do
  visit accept_user_invitation_path(invitation_token: 'invalid_invitation_token')
end

Then /^I should see an invalid invitation token message$/ do
  within('.alert-box') do
    expect(page).to have_content I18n.t('devise.invitations.invitation_token_invalid')
  end
end

Then /^I should see a form to invite a new user$/ do
  expect(page).to have_content 'Invite a new user'
end

Then /^I should find account sign up instuctions$/ do
  expect(current_path).to eq user_sign_up_path
end

Then /^I should find account termination instructions$/ do
  expect(current_path).to eq user_cancel_path
end

Then /^I should be (on|redirected to) the projects page$/ do |foo|
  expect(current_path).to eq projects_path
end
