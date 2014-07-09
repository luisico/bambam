### Methods

def gravatar_hexdigest(user)
  Digest::MD5.hexdigest(user.email.downcase).titleize
end

### Given

### When

When /^I am on (my|the)? account profile page$/ do |foo|
  visit user_path(@user)
end

When /^I click on the user email$/ do
  click_on @user.email
end

### Then

Then /^I should be on (my|the)? account profile page$/ do |foo|
  expect(current_path).to eq user_path(@user)
end

Then /^I should see my email$/ do
  expect(page).to have_content @user.email
end

Then /^I should see my avatar$/ do
  expect(page).to have_xpath("//img[@alt='#{gravatar_hexdigest(@user)}']")
end
