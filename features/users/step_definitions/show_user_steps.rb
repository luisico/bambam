### Methods

### Given

### When

When /^I click on "(.*?)" in the top nav$/ do |account|
  within(".top-bar-section") do
    click_on account
  end
end

When /^I am on my Account Profile page$/ do
  visit user_path(@user)
end

### Then

Then /^I should be on the account profile page$/ do
  expect(current_path).to eq user_path(@user)
end

Then /^I should see my name$/ do
  expect(page).to have_content @user.name
end

Then /^I should see my email$/ do
  expect(page).to have_content @user.email
end

Then /^I should see my avatar$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see a link to "(.*?)"$/ do |link_text|
  expect(page).to have_link link_text
end
