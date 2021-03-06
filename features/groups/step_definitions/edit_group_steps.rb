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
  expect {
    remove_from_select2(User.last.handle_with_email)
    click_button 'Update'
  }.to change(@group.members, :count).by(-1)
  expect(current_path).to eq group_path(@group)
  expect(page).not_to have_content(User.last.handle)
end

Then /^I should be able to update group without changing group owner$/ do
  expect{
    click_button 'Update'
    @group.reload
  }.not_to change(@group, :owner_id)
end

Then /^I should be able to add myself to the group$/ do
  expect {
    fill_in_select2("group_member_ids", with: @admin.handle)
    click_button 'Update'
  }.to change(@group.members, :count).by(1)
  expect(current_path).to eq group_path(@group)
  expect(page).to have_content @admin.handle
end
