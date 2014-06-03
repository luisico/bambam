### Methods

### Given

Given /^there are (\d+) members of that group$/ do |number|
  FactoryGirl.create_list(:user, 3, :groups => [@group])
end

### When

When /^I click on the group name$/ do
  click_link @group.name
end

When /^I am on the group page$/ do
  visit group_path(@group)
end

### Then

Then /^I should be on the show group page$/ do
  expect(current_path).to eq group_path(@group)
end

Then /^I should see the group's name$/ do
  expect(page).to have_content @group.name
end

Then /^I should see the group's members$/ do
  @group.users.each do |user|
    expect(page).to have_content user.email
  end
end

Then /^I should see the group's creation date$/ do
  expect(page).to have_selector "time[data-local='time-ago'][datetime='#{@group.created_at.utc.iso8601}']"
end

Then /^I should see the date of the group's last update$/ do
  expect(page).to have_selector "time[data-local='time-ago'][datetime='#{@group.updated_at.utc.iso8601}']"
end

Then /^I should be able to acess the group page from a link$/ do
  click_link @group.name
  expect(current_path).to eq group_path(@group)
end
