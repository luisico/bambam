### Methods

### Given

### When

When /^I am on the help page$/ do
  visit help_path
end

### Then

Then /^I should see information about the application$/ do
  expect(page).to have_content "Application info"
end

Then /^I should see a FAQ section$/ do
  expect(page).to have_content "FAQ"
end

Then /^I should see information about ABC$/ do
  expect(page).to have_content "About the ABC"
end
