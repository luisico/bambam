### Methods

### Given

Given /^I belong to a project named "(.*?)" with track "(.*?)"( and path "(.*?)")?$/ do |project, track, w_p, path|
  user = @user || @admin
  expect {
    @project = FactoryGirl.create(:project, name: project, users: [user])
    projects_datapath = FactoryGirl.create(:projects_datapath, project: @project)
    if w_p
      @track = FactoryGirl.create(:track, name: track, path: path, projects_datapath: projects_datapath)
    else
      @track = FactoryGirl.create(:track, name: track, projects_datapath: projects_datapath)
    end
  }.to change(Project, :count).by(1)
  expect(@track.project).to eq @project
end

Given /^that project has a user "(.*?)"$/ do |user_email|
  @project.users << FactoryGirl.create(:user, email: user_email)
  @project.reload
end

Given /^I belong to a group named "(.*?)" with member "(.*?)"$/ do |group, member_email|
  user = @user || @admin
  expect {
    @another_user = FactoryGirl.create(:user, email: member_email, last_name: member_email.gsub("@example", ""))
    @group = FactoryGirl.create(:group, name: group, members: [user, @another_user])
  }.to change(Group, :count).by(1)
  expect(@group.members).to include user, @another_user
end

### When

When /^I search for "(.*?)"$/ do |search_term|
  fill_in 'Search', with: search_term
  click_button 'Search'
  @search_term = search_term
end

When /^I click on the "(.*?)" named "(.*?)"$/ do |object_type, name|
  click_link name + "_" + object_type
end

### Then

Then /^I should see my search term in the results page$/ do
  search_box = page.find('#nav_search_box')
  expect(search_box.value).to eq @search_term
end

Then /^I should see a section for projects and tracks$/ do
  within("#projects-and-tracks") {
    expect(page).to have_css ".search-result"
    expect(page).to have_css ".cloud-tag"
    expect(page).to have_css ".width-limited-inline-list"
  }
end

Then /^I should see a section for groups and users$/ do
  within("#groups-and-users") {
    expect(page).to have_css ".search-result"
    expect(page).to have_css ".users-list"
  }
end

Then /^I should see a message that no search results were returned$/ do
  expect(page).to have_content "Your search - #{@search_term} - did not return any results."
end

Then /^I should be on the "(.*?)" page$/ do |model|
  if model == "user"
    expect(current_path).to eq user_path(User.where(email: "best_user@example.com").first)
  else
    expect(current_path).to eq send("#{model}_path", model.capitalize.constantize.first)
  end
end

Then /^I should be on the user show page$/ do
  expect(current_path).to eq user_path(@another_user)
end

Then /^I should not see a search box and button$/ do
  expect(page).not_to have_css "#nav_search_box"
  expect(page).not_to have_css "#nav_search_btn"
end

Then /^I should see the full track path on mouseover$/ do
  expect(page).to have_xpath("//i[@title='#{@track.path}']")
end

Then /^I should be able to toggle track path from truncated to full$/ do
  find('.truncated').trigger('click')
  expect(page).to have_content @track.path
  expect(page).not_to have_content "...54321best12345..."
  find('.truncated').trigger('click')
  expect(page).not_to have_content @track.path
  expect(page).to have_content "...54321best12345..."
end
