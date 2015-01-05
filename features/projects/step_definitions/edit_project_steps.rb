### Methods

### Given

### When

When /^I visit the edit project page$/ do
  visit edit_project_path(@project)
end

### Then

Then /^I should be on the edit project page$/ do
  if @admin
    expect(page).to have_content 'Edit project'
  else
    expect(page).to have_content "Edit #{@project.name}"
  end
end

Then /^I should( not)? be able to edit the project name$/ do |negate|
  if negate
    expect(page).not_to have_field 'Project name'
  else
    expect{
      fill_in 'Project name', with: 'new_project_name'
      click_button 'Update'
      @project.reload
    }.to change(@project, :name)
    expect(page).to have_css('.alert-box', text: 'Project was successfully updated')
  end
end

Then /^I should be able to cancel edit$/ do
  expect {
    fill_in 'Project name', with: 'new_project_name'
    click_link 'Cancel'
  }.not_to change(@project, :name)
end

Then /^I should be able to update project without changing project owner$/ do
  expect{
    click_button 'Update'
    @project.reload
  }.not_to change(@project, :owner_id)
end

Then /^I should be able to add myself to the project$/ do
  expect {
    fill_in_select2("project_user_ids", with: @admin.handle)
    click_button 'Update'
  }.to change(@project.users, :count).by(1)
  expect(current_path).to eq project_path(@project)
  expect(page).to have_content @admin.handle
end

Then /^I should see a button to "(.*?)" project$/ do |text|
  expect(page).to have_link text
end
