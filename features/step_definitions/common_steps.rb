### Methods

### Given

### When

### Then

Then /^the "(.*)" field should have the error "(.*)"$/ do |field, msg|
  form_field_error field, msg
end

Then /^I should see the error message "(.*)"$/ do |msg|
  expect(page).to have_css('.alert', text: msg)
end

Then /^I should be denied access$/ do
  expect(page).to have_css('.flash', text: I18n.t('unauthorized.default'))
end

Then /^I should not find the page$/ do
  expect(page).to have_content "Routing Error"
end
