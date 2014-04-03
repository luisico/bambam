### Methods

### Given

### When

When /^I visit the page to reset my password$/ do
  visit new_user_password_path
end

When /^I ask for reset password instructions$/ do
  step %{I visit the page to reset my password}
  fill_in User.human_attribute_name(:email), with: @visitor[:email]
  click_button 'Send me reset password instructions'
end

When /^I follow the reset password link$/ do
  open_last_email
  visit_in_email edit_user_password_path({:reset_password_token => @user.reset_password_token})
end

When /^I change my password$/ do
  fill_in 'New password', with: @visitor[:password] + '_new'
  fill_in 'Confirm new password', with: @visitor[:password] + '_new'
  click_button 'Change my password'
end

When /^I use a wrong reset password token$/ do
  visit edit_user_password_path(reset_password_token: 'invalid_token')
end

When /^I visit the page to change my password$/ do
  visit edit_user_password_path
end

When /^I ask for reset password instructions with a wrong email address$/ do
  step %{I visit the page to reset my password}
  fill_in User.human_attribute_name(:email), with: "invalid_email@example.org"
  click_button 'Send me reset password instructions'
end

When /^I ask for reset password instructions with a blank email address$/ do
  step %{I visit the page to reset my password}
  fill_in User.human_attribute_name(:email), with: ""
  click_button 'Send me reset password instructions'
end

### Then

Then /^I see an already signed in message$/ do
  expect(page).to have_content I18n.t('devise.failure.already_authenticated')
end

Then /^I should receive an email with reset password instructions$/ do
  open_last_email
  expect(current_email).to have_subject(I18n.t('devise.mailer.reset_password_instructions.subject'))
end

Then /^I should have a reset password token set$/ do
  expect {
    @user.reload
  }.to change(@user, :reset_password_token)
end

Then /^I should see the password change page( again)?$/ do |again|
  expect(page).to have_content 'Change your password'
  if again
    expect(page).to have_content "#{User.human_attribute_name(:reset_password_token).capitalize} #{I18n.t('errors.messages.invalid')}"
  end
end

Then /^I should see the password changed successfully message$/ do
  expect(page).to have_content I18n.t('devise.passwords.updated_not_active')
end

Then /^I should see the password reset sent email instructions page$/ do
  expect(page).to have_button 'Send me reset password instructions'
end
