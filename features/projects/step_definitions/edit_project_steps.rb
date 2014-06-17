### Methods

### Given

### When

When /^I click on the project edit link$/ do
  click_link 'Edit'
end

When /^I visit the edit project page$/ do
  visit edit_project_path(@project)
end

### Then

Then /^I should be on the edit project page$/ do
  expect(page).to have_content 'Edit project'
end

Then /^I should be able to edit the project name$/ do
  expect{
    fill_in 'Project name', with: 'new_project_name'
    click_button 'Update'
    @project.reload
  }.to change(@project, :name)
  expect(page).to have_css('.alert-box', text: 'Project was successfully updated')
end

Then /^I should be able to edit the project users$/ do
  expect {
    uncheck User.last.email
    click_button 'Update'
  }.to change(@project.users, :count).by(-1)
  expect(current_path).to eq project_path(@project)
  expect(page).not_to have_content(User.last.email)
end

Then /^I should be able to edit the project tracks$/ do
  expect {
    uncheck @project.tracks.last.name
    click_button 'Update'
  }.to change(@project.tracks, :count).by(-1)
  expect(current_path).to eq project_path(@project)
  expect(page).not_to have_content(Track.last.name)
end

Then /^I should be able to update project without changing project owner$/ do
  expect{
    click_button 'Update'
    @project.reload
  }.not_to change(@project, :owner_id)
end

Then /^I should be able to add myself to the project$/ do
  expect {
    check @admin.email
    click_button 'Update'
  }.to change(@project.users, :count).by(1)
  expect(current_path).to eq project_path(@project)
  expect(page).to have_content @admin.email
end
