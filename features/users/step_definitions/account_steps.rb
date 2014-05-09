### Methods

def update_account
  fill_in 'user_current_password', with: @user.password
  click_button 'Update'
end

### Given

Given /^I am on my account settings page$/ do
  visit user_path(@user)
end

### When

When /^I visit the edit account page$/ do
  visit edit_user_registration_path
end

### Then

Then /^I should be on the edit account page$/ do
  expect(page).to have_content 'Update account'
end

Then /^I should be able to edit my email$/ do
  expect {
    fill_in 'Email', with: 'new@email.com'
    update_account
    @user.reload
  }.to change(@user, :email)
  expect(page).to have_css('.alert-box', text: I18n.t('devise.registrations.updated'))
end

Then /^I should be able to edit my password$/ do
  new_password = 'new_password'
  expect {
    fill_in 'user_password', with: new_password
    fill_in 'user_password_confirmation', with: new_password
    update_account
    @user.reload
  }.to change(@user, :encrypted_password)
  expect(page).to have_css('.alert-box', text: I18n.t('devise.registrations.updated'))
end

Then /^I should not be able to edit my password with an invalid current password$/ do
  new_password = 'new_password'
  expect {
    fill_in 'user_password', with: new_password
    fill_in 'user_password_confirmation', with: new_password
    fill_in 'user_current_password', with: 'wrong_password'
    click_button 'Update'
    @user.reload
  }.not_to change(@user, :encrypted_password)
end

Then /^I should not be able to edit my password if it is invalid$/ do
  new_password = 'short'
  expect {
    fill_in 'user_password', with: new_password
    fill_in 'user_password_confirmation', with: new_password
    update_account
    @user.reload
  }.not_to change(@user, :encrypted_password)
end

Then /^I should not be able to edit my password if password confirmation is wrong$/ do
  new_password = 'new_password'
  expect {
    fill_in 'user_password', with: new_password
    fill_in 'user_password_confirmation', with: ''
    update_account
    @user.reload
  }.not_to change(@user, :encrypted_password)
end
