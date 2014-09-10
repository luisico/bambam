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

Then /^I should( not)? be able to change memberships in the project$/ do |negate|
  if negate
    expect(page).not_to have_selector(:xpath, "//input[@name='project[user_ids][]']")
  else
    expect(page).to have_selector(:xpath, "//input[@name='project[user_ids][]']")
    deleted = []
    expect {
      @project.users[-2..-1].each{ |u| uncheck u.email; deleted << u }
      @users.each{ |u| check u.email}
      click_button 'Update'
      @project.reload
    }.to change(@project.users, :count).by(1)
    expect(current_path).to eq project_path(@project)
    deleted.each do |u|
      expect(@project.users).not_to include(u)
      expect(page).not_to have_content(u.email)
    end
    @users.each do |u|
      expect(@project.users).to include(u)
      expect(page).to have_content(u.email)
    end
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

Then /^I should see a button to "(.*?)" project$/ do |text|
  expect(page).to have_link text
end
