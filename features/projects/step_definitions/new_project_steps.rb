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

# def add_track_to_project
#   click_link 'Add a track'
#   within('.new-record') {
#     fill_track_form
#     expect(page).not_to have_content "Assign track to a project"
#   }
# end

### Given

### When

# When /^I create a new project with a user and a track$/ do
#   expect{
#     build_project
#     add_track_to_project
#     fill_project_form
#   }.to change(Project, :count).by(1)
# end

# When /^I create a project without a name$/ do
#   expect{
#     build_project
#     fill_in 'Project name', with: @project_attrs.merge(name: '')[:name]
#     click_button 'Create Project'
#   }.not_to change(Project, :count)
# end

# When /^I create a project with multiple users$/ do
#   expect {
#     build_project
#     fill_project_form do
#       fill_in_select2("project_user_ids", with: User.all[-2].handle)
#     end
#   }.to change(Project, :count).by(1)
# end

# When /^I create a project with multiple tracks$/ do
#   expect {
#     build_project
#     add_track_to_project
#     click_link 'Add another track'
#     second_track = page.all(:css, '.new-record')[1]
#     within(second_track) {
#       fill_track_form
#     }
#     fill_project_form
#   }.to change(Project, :count).by(1)
# end

# When /^I delete a track before creating project$/ do
#   expect {
#     build_project
#     add_track_to_project
#     find('.remove-track').trigger('click')
#     fill_project_form
#   }.to change(Project, :count).by(1)
#   expect(current_path).to eq project_path(Project.last)
# end

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

# Then /^I should( not)? see myself listed as project owner$/ do |negate|
#   current_user = (@admin || @manager)
#   if negate
#     within('#project-owner') {
#       expect(page).not_to have_content current_user.handle
#     }
#   else
#     within('#project-owner') {
#       expect(page).to have_content current_user.handle
#     }
#   end
# end

# Then /^I should see a list of potential users$/ do
#   find("#s2id_project_user_ids").click
#   within(".select2-results") {
#     expect(page).not_to have_content @manager.handle
#     @users.each do |user|
#       expect(page).to have_content user.handle
#     end
#   }
# end

Then /^I should see a message that the project was created successfully$/ do
  expect(page).to have_content('Project was successfully created')
end

Then /^I should see my handle among the list of project member handles$/ do
  expect(page).to have_content User.first.handle
end

Then /^I should be the project's owner$/ do
  expect(Project.last.owner).to eq(@manager)
end

# Then /^I should see all project members$/ do
#   expect(page).to have_content Project.last.owner.handle
#   expect(page).to have_content User.last.handle
#   expect(page).to have_content User.all[-2].handle
# end

# Then /^I should see all the project tracks$/ do
#   project = @project || Project.last
#   expect(project.tracks.count).to be > 0
#   project.tracks.each do |track|
#     expect(page).to have_link track.name
#   end
# end

# Then /^I should not create a new track$/ do
#   expect(Track.count).to eq(0)
#   expect(page).not_to have_link @track[:name]
# end
