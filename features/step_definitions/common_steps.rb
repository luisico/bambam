### Methods

### Given

### When

When /^environment variable (.*?) is "(.*?)"$/ do |name, value|
  ENV[name] = value
end

### Then

Then /^the "(.*)" field should have the error "(.*)"$/ do |field, msg|
  form_field_error field, msg
end

Then /^I should see the error message "(.*)"$/ do |msg|
  expect(page).to have_css('.alert', text: msg)
end

Then /^I should be denied access$/ do
  expect(page).to have_css('.alert-box', text: I18n.t('unauthorized.default'))
end

Then /^I should not find the page$/ do
  expect(page).to have_content "Routing Error"
end

Then /^I should see button to copy the (.*) to the clipboard$/ do |text|
  clipboard_id = text.split(/\s+/).join('_')
  expect(page).to have_selector("[data-clipboard-id=#{clipboard_id}]")
  expect(page).to have_selector("##{clipboard_id}")
end
