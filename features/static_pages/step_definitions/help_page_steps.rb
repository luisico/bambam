### Methods

### Given

### When

When /^I am on the help page$/ do
  visit help_path
end

### Then

Then /^I should see a section about what is bambam$/ do
  expect(page).to have_content "What is Bambam?"
end

Then /^I should see a section about using bambam$/ do
  expect(page).to have_content "Using Bambam"
end

Then /^I should see a section about ABC$/ do
  expect(page).to have_content "About the Applied Bioinformatics Core"
end
