### Methods

### Given

### When

### Then

Then /^I should see a sign in link$/ do
  expect(page).to have_link I18n.t('devise.sessions.sign_in')
end

Then /^I should see a forgot password link$/ do
  expect(page).to have_link I18n.t('devise.passwords.forgot')
end
