### Methods

def build_project
  @project_attrs ||= FactoryGirl.attributes_for(:project)
end

def fill_project_form(project=nil)
  click_link "New Project"
  project ||= @project_attrs
  fill_in 'Name', with: project[:name]
  fill_in 'Description', with: project[:desc]
end

def submit_project_form(content)
  click_button 'Create Project'
  expect(page).to have_content content
end

### Given

### When

### Then

Then /^I should see a new project form$/ do
  expect(page).to have_css "form#new_project"
end

Then /^I should be able to create a new project$/ do
  build_project
  expect {
    fill_project_form
    submit_project_form(@project_attrs[:name])
  }.to change(Project, :count).by(1)
  @project = Project.last
end

Then /^I should not be able to create a new project without a name$/ do
  expect {
    fill_project_form({name: ""})
    submit_project_form("can't be blank")
  }.not_to change(Project, :count)
end

Then /^I should be able to create a new project without a description$/ do
  new_project_attr = {name: "new_project", desc: ""}
  expect {
    fill_project_form(new_project_attr)
    submit_project_form(new_project_attr[:name])
  }.to change(Project, :count).by(1)
end

Then /^I should be able to cancel new project$/ do
  build_project
  expect {
    fill_project_form
    click_link "Cancel"
    expect(page).to have_link "New Project"
  }.not_to change(Project, :count)
end

Then /^I should see a message that the project was created successfully$/ do
  expect(page).to have_content('Project was successfully created')
end

Then /^I should not see my handle among the list of project member handles$/ do
  within("#project-users"){
    expect(page).not_to have_content @project.owner.handle
  }
end

Then /^I should see myself listed as the project's owner$/ do
  within("#project-name") {
    expect(page).to have_content @project.owner.handle
  }
end
