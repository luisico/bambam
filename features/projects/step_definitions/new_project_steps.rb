### Methods

def build_project
  @project_attrs ||= FactoryGirl.attributes_for(:project)
  build_track_with_path
end

def fill_project_form(project=nil)
  project ||= @project_attrs
  fill_in 'Project name', with: project[:name]
  check User.last.email
  yield if block_given?
  click_button 'Create Project'
end

def add_track_to_project
  click_link 'Add Track'
  within('.new-record') {
    fill_track_form
  }
end

### Given

Given /^I am on the new project page$/ do
  visit new_project_path
end

### When

When /^I create a new project with a user and a track$/ do
  expect{
    build_project
    add_track_to_project
    fill_project_form
  }.to change(Project, :count).by(1)
end

When /^I create a project without a name$/ do
  expect{
    build_project
    fill_project_form @project_attrs.merge(name: '')
  }.not_to change(Project, :count)
end

When /^I create a project with multiple members$/ do
  expect {
    build_project
    fill_project_form do
      check User.all[-2].email
    end
  }.to change(Project, :count).by(1)
end

When /^I create a project with multiple tracks$/ do
  expect {
    build_project
    add_track_to_project
    click_link 'Add Track'
    second_track = page.all(:css, '.new-record')[1]
    within(second_track) {
      fill_track_form
    }
    fill_project_form
  }.to change(Project, :count).by(1)
end

When /^I delete a track before creating project$/ do
  expect {
    build_project
    add_track_to_project
    find('.remove-track').trigger('click')
    fill_project_form
  }.to change(Project, :count).by(1)
  expect(current_path).to eq project_path(Project.last)
end

### Then

Then /^I should be on the new project page$/ do
  expect(page).to have_content 'New project'
end

Then /^I should see unchecked checkboxes for the other users$/ do
  @users.each do |user|
    expect(page).to have_unchecked_field user.email
  end
end

Then /^I should be on the project show page$/ do
  expect(current_path).to eq project_path(Project.last)
end

Then /^I should see a message that the project was created successfully$/ do
  expect(page).to have_content('Project was successfully created')
end

Then /^I should see my email among the list of project member emails$/ do
  expect(page).to have_content User.first.email
end

Then /^I should be the project's owner$/ do
  expect(Project.last.owner).to eq(@admin)
end

Then /^I should see all project members$/ do
  expect(page).to have_content Project.last.owner.email
  expect(page).to have_content User.last.email
  expect(page).to have_content User.all[-2].email
end

Then /^I should be able to cancel new project$/ do
  expect {
    click_link "Cancel"
  }.not_to change(Project, :count)
end

Then /^I should see all the project tracks$/ do
  project = @project || Project.last
  expect(project.tracks.count).to be > 0
  project.tracks.each do |track|
    expect(page).to have_link track.name
  end
end

Then /^I should not create a new track$/ do
  expect(Track.count).to eq(0)
  expect(page).not_to have_link @track[:name]
end

