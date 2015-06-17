### Methods

### Given

### When

When /^I am on the help page$/ do
  visit help_path
end

### Then

Then /^I should see a section title "(.*?)"$/ do |title|
  expect(page).to have_css "h4", text: title
end
