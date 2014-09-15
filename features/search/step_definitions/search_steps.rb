### Methods

### Given

Given /^I belong to a project a project called "(.*?)"$/ do |name|
  user = User.last
  expect {
    @project = FactoryGirl.create(:project, name: name, users: [user])
  }.to change(Project, :count).by(1)
end

Given /^there is a track in that project called "(.*?)"$/ do |name|
  @project ||= @projects.last
  FactoryGirl.create(:test_track, name: name, :project => @project)
  @track = @project.tracks.last
end

Given /^I belong to a group called "(.*?)"$/ do |name|
  expect {
    @group = FactoryGirl.create(:group, name: name, members: [@user])
  }.to change(Group, :count).by(1)
end

Given /^there is another user in the system with email "(.*?)"$/ do |email|
  expect {
    @another_user = FactoryGirl.create(:user, email: email)
  }.to change(User, :count).by(1)
end

### When

When /^I search for "(.*?)"$/ do |search_term|
  fill_in 'Search', with: search_term
  click_button 'Search'
  @search_term = search_term
end

### Then

Then /^I should( not)? see a list of all objects that contain the name "(.*?)"$/ do |negate, name|
  object_array = ["_project", "_track", "_group"]
  if negate
    object_array.each do |object|
      expect(page).not_to have_content name + object
    end
  else
    object_array.each do |object|
      expect(page).to have_content name + object
    end
  end
end

Then /^I should see a message that no search results were returned$/ do
  expect(page).to have_content "Your search - #{@search_term} - did not return any results."
end
