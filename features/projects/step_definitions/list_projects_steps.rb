### Methods

### Given

### When

When /^I am on the projects page$/ do
  visit projects_path
end

When /^I click on the project name$/ do
  click_link @project.name
end

### Then

Then /^I should see a list of projects$/ do
  expect(Project.count).to be > 0
  Project.all.each do |project|
    expect(page).to have_css "#project_#{project.id}"
    within("#project_#{project.id}") do
      expect(page).to have_content project.name
      expect(page).to have_content project.tracks.count
      expect(page).to have_link project.owner.email
      expect(page).to have_selector "time[data-local='time-ago'][datetime='#{project.updated_at.utc.iso8601}']"
    end
  end
end

Then /^I should only see a list of my projects$/ do
  expect(Project.count).to be > 0
  projects = Project.all
  user_projects = projects.keep_if{|p| p.users.include? @user}

  user_projects.each do |project|
    expect(page).to have_css "#project_#{project.id}"
    within("#project_#{project.id}") do
      expect(page).to have_content project.name
      expect(page).to have_content project.tracks.count
      expect(page).to have_content project.owner.email
      expect(page).not_to have_link project.owner.email
      expect(page).to have_selector "time[data-local='time-ago'][datetime='#{project.updated_at.utc.iso8601}']"
    end
  end
  (projects - user_projects).each do |project|
    expect(page).not_to have_css "#project_#{project.id}"
  end
end
