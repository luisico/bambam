### Methods

def project_details(project, user_link)
  within("#project_#{project.id}") do
    expect(page).to have_content project.name
    expect(page).to have_content project.tracks.count
    if user_link
      expect(page).to have_link project.owner.handle
    else
      expect(page).not_to have_link project.owner.handle
    end
    expect(page).to have_selector "time[data-local='time-ago'][datetime='#{project.updated_at.utc.iso8601}']"
  end
end

### Given

Given /^I do( not)? have an manager$/ do |negate|
  unless negate
    @admin = FactoryGirl.create(:admin)
    @user.invited_by = @admin
    @user.save!
  end
end

### When

When /^I am on the projects page$/ do
  visit projects_path
end

When /^I click on the project name$/ do
  click_link @project.name
end

When /^I filter projects on "(.*?)"$/ do |projects_filter|
  fill_in 'Filter projects', with: projects_filter
  click_button 'Filter'
  loop until page.evaluate_script('jQuery.active').zero?
  @projects_filter = projects_filter
end

When /^I click on clear$/ do
  click_link 'Clear', exact: true
  loop until page.evaluate_script('jQuery.active').zero?
end

### Then

Then /^I should see a list of all projects$/ do
  expect(Project.count).to be > 0
  Project.all.each do |project|
    project_details project, true
  end
end

Then /^I should only see a list of projects I belong to$/ do
  expect(Project.count).to be > 0
  Project.all.each do |project|
    if project.users.include?(@user)
      project_details project, false
    else
      expect(page).not_to have_css "#project_#{project.id}"
    end
  end
end

Then /^I should only see a list of projects I own or belong to$/ do
  expect(Project.count).to be > 0
  Project.all.each do |project|
    if project.users.include?(@manager) || project.owner == @manager
      project_details project, true
    else
      expect(page).not_to have_css "#project_#{project.id}"
    end
  end
end

Then /^I should see a special message$/ do
  if @user.invited_by
    expect(page).to have_content "Please contact #{@admin.email} to be added to a project"
  else
    expect(page).to have_content "Please contact your admin to be added to a project"
  end
end

Then /^I should see (\d+|a) projects?$/ do |n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)

  project_count = page.all('.project-tile').count
  expect(project_count).to eq n
end

Then /^I should see a no matches message$/ do
  expect(page).to have_content 'No projects found.'
end

Then /^the input field should be clear$/ do
  expect(find('#filter').value).to eq ''
end
