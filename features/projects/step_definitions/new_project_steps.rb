### Methods

def build_project
  @project ||= FactoryGirl.attributes_for(:project)
end

def fill_project_form(project=nil)
  project ||= @project
  fill_in 'Project name', with: project[:name]
  check User.last.email
  check Track.last.name
  yield if block_given?
  click_button 'Create Project'
end

### Given

Given /^I am on the new project page$/ do
  visit new_project_path
end

### When

When /^I follow the new project link$/ do
  click_link 'New Project'
end

When /^I create a new project$/ do
  expect{
    build_project
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
    fill_project_form do
      check Track.all[-2].name
    end
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
