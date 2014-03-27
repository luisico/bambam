### Methods

### Given

Given /^I am on the home page$/ do
  visit root_path
end

### When

### Then

Then /^I should be (on|redirected to) the home page$/ do |foo|
  expect(current_path).to eq root_path
end

Then /^I should see the text "(.*?)"$/ do |text|
  expect(page).to have_content text
end
