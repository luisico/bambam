### Methods

### Given

### When

When /^I visit the edit project page$/ do
  visit edit_project_path(@project)
end

### Then

Then /^I should be on the edit project page$/ do
  expect(page).to have_content 'Edit project'
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

Then /^I should( not)? be able to delete (\d+|a) users? from the project$/ do |negate, n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)
  if negate
    expect(page).not_to have_content User.last.email
  else
    expect {
      i = n
      while i > 0 do
        uncheck User.all[-i].email
        i -= 1
      end
      click_button 'Update'
    }.to change(@project.users, :count).by(-n)
    expect(current_path).to eq project_path(@project)
    expect(page).not_to have_content(User.last.email)
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
    check @admin.email
    click_button 'Update'
  }.to change(@project.users, :count).by(1)
  expect(current_path).to eq project_path(@project)
  expect(page).to have_content @admin.email
end
