### Methods

### Given

Given /^I belong to a project a project called "(.*?)"$/ do |name|
  user = @user || @admin
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
  @user ||= User.last
  expect {
    @group = FactoryGirl.create(:group, name: name, members: [@user])
  }.to change(Group, :count).by(1)
end

Given /^there is another user in that group with email "(.*?)"$/ do |email|
  expect {
    @another_user = FactoryGirl.create(:user, email: email, groups: [@group])
  }.to change(User, :count).by(1)
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

Then /^I should only see a list of "(.*?)" that contain the name "(.*?)"$/ do |col, term|
  col_list = page.find("##{col.gsub(" ", "-")}")
  if col == "projects and tracks"
    [Project, Track].each do |object_type|
      expect(col_list).not_to have_content object_type.last.name
      object_type.all[0...-1].each do |object|
        expect(col_list).to have_content object.name
      end
    end
  else
    users = User.where.not(id: User.with_role(:admin))
    within(col_list) {
      expect(col_list).not_to have_content Group.last.name
      Group.all[0...-1].each do |group|
        expect(col_list).to have_content group.name
      end
      expect(col_list).not_to have_content users.last.email
      users[0...-1].each do |user|
        expect(col_list).to have_content user.email
      end
    }
  end
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
