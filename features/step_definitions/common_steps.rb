### Methods

def fill_in_select2(selector, options={})
  page.find(:css, "#s2id_#{selector}").click
  page.find(:css, ".select2-search-field input.select2-input").set options[:with]
  page.find(:css, ".select2-result-label").click
end

def remove_from_select2(element_text)
  page.find(:xpath, "//li[div/text()='#{element_text}']/a").click
end

### Given

### When

When /^environment variable (.*?) is "(.*?)"$/ do |name, value|
  ENV[name] = value
end

When /^I click "(.*?)"$/ do |link|
  click_link link
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
  clipboard_id = 'clip_'+ text.split(/\s+/).join('_')
  expect(page).to have_selector("[data-clipboard-id=#{clipboard_id}]")
  expect(page).to have_selector("##{clipboard_id}")
end

Then /^I should( not)? see a link to "(.*?)"$/ do |negate, text|
  if negate
    expect(page).not_to have_link text
  else
    expect(page).to have_link text
  end
end

Then /^I should( not)? see an? "(.*?)" button$/ do |negate, text|
  step %{I should#{negate} see a link to "#{text}"}
end

Then /^I should see the (.*?)'s timestamps$/ do |model|
  object = eval "@#{model}"
  expect(page).to have_selector(:xpath, "//div[contains(@class,'created-at') and contains(.,time[@data-local='time-ago' and @datetime='#{object.created_at.utc.iso8601}'])]")
  expect(page).to have_selector(:xpath, "//div[contains(@class,'updated-at') and contains(.,time[@data-local='time-ago' and @datetime='#{object.updated_at.utc.iso8601}'])]")
end
