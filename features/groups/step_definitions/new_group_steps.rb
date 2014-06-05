### Methods

def build_group
  @group ||= FactoryGirl.attributes_for(:group)
end

def fill_group_form(group=nil)
  group ||= @group
  fill_in 'Group name', with: group[:name]
  check User.last.email
  click_button 'Create Group'
end

### Given

Given /^I am on the new group page$/ do
  visit new_group_path
end

### When

When /^I follow the new group link$/ do
  click_link 'New Group'
end

When /^I create a new group$/ do
  expect{
    build_group
    fill_group_form
  }.to change(Group, :count).by(1)
end

When /^I create a group without a name$/ do
  expect{
    build_group
    fill_group_form @group.merge(name: '')
  }.to change(Group, :count).by(0)
end

### Then

Then /^I should be on the new group page$/ do
  expect(page).to have_content 'New group'
end

Then /^my checkbox should be disabled$/ do
  field_labeled(User.first.email, disabled: true)
end

Then /^I should be on the group show page$/ do
  expect(current_path).to eq group_path(Group.last)
end

Then /^I should see a message that the group was created successfully$/ do
  expect(page).to have_content('Group was successfully created')
end

Then /^I should see my email among the list of group member emails$/ do
  expect(page).to have_content User.first.email
end
