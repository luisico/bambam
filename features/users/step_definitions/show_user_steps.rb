### Methods

### Given

### When

When /^I am on my Account Profile page$/ do
  visit user_path(@user)
end

When /^I click on the user email$/ do
  click_on @user.email
end

### Then

Then /^I should be on the account profile page$/ do
  expect(current_path).to eq user_path(@user)
end

Then /^I should see my email$/ do
  expect(page).to have_content @user.email
end

Then /^I should see my avatar$/ do
  expect(page).to have_xpath("//img[@alt='#{Digest::MD5.hexdigest(@user.email.downcase).titleize}']")
end
