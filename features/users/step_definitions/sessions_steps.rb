### Methods

def sign_in
  visit '/users/sign_in'
  fill_in 'Email', with: @visitor[:email]
  fill_in 'Password', with: @visitor[:password]
  click_button I18n.t('devise.sessions.sign_in')
end

### Given

Given /^I am not signed in$/ do
  visit '/users/sign_out'
  step %{I should be signed out}
end

Given /^I am signed in( as a user)?$/ do |foo|
  step %{I exist as a user}
  step %{I sign in}
  step %{I should be signed in}
end

Given /^I am signed in as an? (admin|inviter)$/ do |role|
  send("create_#{role}")
  visit '/users/sign_in'
  fill_in 'Email', with: instance_variable_get("@#{role}").email
  fill_in 'Password', with: instance_variable_get("@#{role}").password
  click_button I18n.t('devise.sessions.sign_in')
  step %{I should be signed in}
end

### When

When /^I sign in( with valid email and password)?$/ do |foo|
  sign_in
end

When /^I sign in with an invalid email address$/ do
  @visitor.merge!(email: "wrong@example.com")
  sign_in
end

When /^I sign in with an invalid password$/ do
  @visitor.merge!(password: "wrongpass")
  sign_in
end

When /^I sign out$/ do
  visit '/users/sign_out'
end

When /^I visit the sign in page$/ do
  visit '/users/sign_in'
end

### Then

Then /^I should be signed in$/ do
  within('.top-bar') do
    expect(page).to have_content I18n.t('devise.sessions.sign_out')
    expect(page).not_to have_content I18n.t('devise.sessions.sign_in')
  end
end

Then /^I should be signed out$/ do
  within('.top-bar') do
    expect(page).to have_content I18n.t('devise.sessions.sign_in')
    expect(page).not_to have_content I18n.t('devise.sessions.sign_out')
  end
end

Then /^I should see a successful sign in message$/ do
  expect(page).to have_css '.alert-box', text: I18n.t('devise.sessions.signed_in')
end

Then /^I should see a signed out message$/ do
  expect(page).to have_css '.alert-box', text: I18n.t('devise.sessions.signed_out')
end

Then /^I should see an invalid sign in message$/ do
  expect(page).to have_css '.alert-box', text: I18n.t('devise.failure.invalid')
end
