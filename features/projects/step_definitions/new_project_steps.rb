### Methods

def build_project
  @project ||= FactoryGirl.attributes_for(:project)
  build_track_with_path
end

def fill_project_form(project=nil)
  project ||= @project
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

When /^I follow the new project link$/ do
  click_link 'New Project'
end

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
    fill_project_form @project.merge(name: '')
  }.to change(Project, :count).by(0)
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

### Then

Then /^I should be on the new project page$/ do
  expect(page).to have_content 'New project'
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

Then /^I should be the projects owner$/ do
  expect(Project.last.owner).to eq(@user)
end

Then /^all the project member email addresses should be on the list$/ do
  expect(page).to have_content Project.last.owner.email
  expect(page).to have_content User.last.email
  expect(page).to have_content User.all[-2].email
end

Then /^all the project track names should be on the list$/ do
  expect(page).to have_content Track.last.name
  expect(page).to have_content Track.all[-2].name
end
