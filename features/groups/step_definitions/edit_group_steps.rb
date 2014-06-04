### Methods

### Given

### When

When /^I click on the group edit link$/ do
  click_link 'Edit'
end

When /^I visit the edit group page$/ do
  visit edit_group_path(@group)
end

### Then

Then /^I should be on the edit group page$/ do
  expect(page).to have_content 'Edit group'
end

Then /^I should be able to edit the group name$/ do
  expect{
    fill_in 'Group name', with: 'new_group_name'
    click_button 'Update'
    @group.reload
  }.to change(@group, :name)
  expect(page).to have_css('.alert-box', text: 'Group was successfully updated')
end

Then /^I should be able to edit the group members$/ do
  expect{
    uncheck User.last.email
    click_button 'Update'
    @group.reload
    }.to change(@group.user_ids, :length).by(-1)
  expect(page).to have_css('.alert-box', text: 'Group was successfully updated')
end
