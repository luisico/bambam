### Methods

def build_project
  @project_attrs ||= FactoryGirl.attributes_for(:project)
  # build_track_with_path
end

def fill_project_form(project=nil)
  click_link "New Project"
  project ||= @project_attrs
  fill_in 'Project name', with: project[:name]
end

def submit_project_form(options={})
  if options[:cancel]
    click_link "Cancel"
  else
    click_button 'Create Project'
    expect(page).to have_content options[:content]
  end
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
    submit_project_form(content: @project_attrs[:name])
  }.to change(Project, :count).by(1)
  @project = Project.last
end

Then /^I should not be able to create a new project without a name$/ do
  expect {
    fill_project_form({:name=>""})
    submit_project_form(content: "can't be blank")
  }.not_to change(Project, :count)
end

Then /^I should be able to cancel new project$/ do
  build_project
  expect {
    fill_project_form
    submit_project_form(cancel: true)
  }.not_to change(Project, :count)
  expect(page).to have_link "New Project"
end

Then /^I should see a message that the project was created successfully$/ do
  expect(page).to have_content('Project was successfully created')
end

Then /^I should see my handle among the list of project member handles$/ do
  expect(page).to have_content User.first.handle
end

Then /^I should be the project's owner$/ do
  expect(Project.last.owner).to eq(@manager)
end
