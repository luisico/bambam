### Methods

### Given

Given /^one of my projects is in the system$/ do
  @project = FactoryGirl.create(:project, owner: @user)
  @track = FactoryGirl.create(:track, :project => @project)
  @project.users << @user
end

### When

When /^I click on the project name$/ do
  click_link @project.name
end

When /^I am on the project page$/ do
  visit project_path(@project)
end

### Then

Then /^I should be on the show project page$/ do
  expect(current_path).to eq project_path(@project)
end

Then /^I should see the project's name$/ do
  expect(page).to have_content @project.name
end

Then /^I should see the projects tracks$/ do
  @project.tracks.each do |track|
    expect(page).to have_content track.name
  end
end

Then /^I should see the project's users$/ do
  @project.users.each do |user|
    expect(page).to have_content user.email
  end
end

Then /^I should see the project's creation date$/ do
  expect(page).to have_selector "time[data-local='time-ago'][datetime='#{@project.created_at.utc.iso8601}']"
end

Then /^I should see the date of the project's last update$/ do
  expect(page).to have_selector "time[data-local='time-ago'][datetime='#{@project.updated_at.utc.iso8601}']"
end
