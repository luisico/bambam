### Methods

### Given

Given /^there is a read only user in that project$/ do
  @projects_user = @project.projects_users.first
  @projects_user.update_attributes(read_only: true)
  expect(@projects_user.read_only).to eq true
end

### When

When /^I am on the project page$/ do
  visit project_path(@project)
end

### Then

Then /^I should be on the project page$/ do
  expect(current_path).to eq project_path(@project)
end

Then /^I should see the project's name$/ do
  expect(page).to have_content @project.name
end

Then /^I should see the project's tracks$/ do
  project = @project || Project.last
  project.tracks.each do |track|
    expect(page).to have_link track.name
    expect(page).to have_selector(:xpath, "//a[contains(@href, 'http://localhost:60151/load') and text()='igv']")
  end
end

Then /^I should see the project's users with(out)? profile links$/ do |negate|
  @project ||= Project.last
  if negate
    @project.users.each do |user|
      within("#user-#{user.id}") do
        if user != @user
          expect(page).to have_content user.handle
          expect(page).not_to have_link user.handle
        else
          expect(page).to have_link user.handle
        end
      end
    end
  else
    @project.users.each do |user|
      within("#user-#{user.id}") do
        expect(page).to have_link user.handle
      end
    end
  end
end

Then /^I should see the project's owner$/ do
  project = @project || Project.last
  within("#user-#{project.owner.id}") do
    expect(page).to have_css('.admin-icon')
  end
end

Then /^I should be on the tracks page$/ do
  expect(current_path).to eq tracks_path
end

Then /^I should be able to designate a user read only$/ do
  @projects_user = @project.projects_users.first
  expect {
    within("#edit_projects_user_#{@projects_user.id}") {
      check "projects_user[read_only]"
    }
    sleep 1
    @projects_user.reload
  }.to change(@projects_user, :read_only)
end

Then /^that user should move to the read\-only list$/ do
  user = User.find(@projects_user.user_id)
  within("#project-users-regular") {
    expect(page).not_to have_content user.handle
  }
  within("#project-users-read-only") {
    expect(page).to have_content user.handle
  }
end

Then /^I should be able to remove a user from the read only list$/ do
  expect {
    within("#edit_projects_user_#{@projects_user.id}") {
      uncheck "projects_user[read_only]"
    }
    sleep 1
    @projects_user.reload
  }.to change(@projects_user, :read_only)
end

Then /^that user should move to the regular user list$/ do
  user = User.find(@projects_user.user_id)
  within("#project-users-regular") {
    expect(page).to have_content user.handle
  }
  within("#project-users-read-only") {
    expect(page).not_to have_content user.handle
  }
end

Then /^the regular user counts should be (\d+)$/ do |n|
  expect(find("#regular-users").text).to include n
end

Then /^the read only user count should be (\d+)$/ do |n|
  expect(find("#read-only-users").text).to include n
end
