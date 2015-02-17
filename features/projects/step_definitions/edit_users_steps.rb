### Methods

### Given

### When

### Then

Then /^I should( not)? be able to change users in the project$/ do |negate|
  if negate
    expect(page).not_to have_link "Edit Project Users"
  else
    click_link "Edit Project Users"
    deleted = []

    expect {
      @project.users[-2..-1].each { |u| remove_from_select2(u.handle_with_email); deleted << u }
      @users.each { |u| fill_in_select2("project_user_ids", with: u.handle)}
      click_button 'Update'
      expect(page).to have_content "Read-Only Users"
      @project.reload
    }.to change(@project.users, :count).by(1)
    expect(current_path).to eq project_path(@project)

    deleted.each do |u|
      expect(@project.users).not_to include(u)
      expect(page).not_to have_content(u.handle)
    end

    @users.each do |u|
      expect(@project.users).to include(u)
      expect(page).to have_content(u.handle)
    end
  end
end

Then /^I should be able to cancel out of the edit project user form$/ do
  expect {
    click_link "Edit Project Users"
    within (".edit_project") {
      expect(page).to have_content "Edit Project Users"
      click_link "Cancel"
    }
    @project.reload
  }.not_to change(@project, :users)
  expect(page).to have_content "Read-Only Users"
end
