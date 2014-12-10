### Methods

### Given

Given /^there is( not)? a "(.*?)" link in the navigation bar$/ do |negate, link_text|
  if negate
    expect(page).not_to have_css('li a', text: link_text)
  else
    expect(page).to have_css('li a', text: link_text)
  end
end

### When

When /^I click on "(.*?)" in the top nav$/ do |link|
  within(".top-bar") do
    if link == "my email"
      click_on @user.email
    else
      click_on link
    end
  end
end

### Then

Then /^I should be on the root page$/ do
  expect(current_path).to eq root_path
end

Then /^I should be on (my|the)? account profile page$/ do |foo|
  expect(current_path).to eq user_path(@user)
end

Then /^I should be on the help page$/ do
  expect(current_path).to eq help_path
end
