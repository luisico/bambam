### Methods

### Given

### When

When /^I am on the projects page$/ do
  visit projects_path
end

### Then

Then /^I should see a list of projects$/ do
  expect(Project.count).to be > 0
  Project.all.each do |project|
    expect(page).to have_content project.name
  end
end

Then /^I should only see a list of my projects$/ do
  expect(Project.count).to be > 0
  projects = Project.all
  user_projects = projects.keep_if{|p| p.users.include? @user}

  user_projects.each do |project|
    within("#project_#{project.id}") do
      expect(page).to have_content project.name
      expect(page).to have_content project.tracks.count
      expect(page).to have_content project.owner.email
    end
  end
  (projects - user_projects).each do |project|
    within("#project_#{project.id}") do
      expect(page).not_to have_content project.name
      expect(page).to have_content project.tracks.count
      expect(page).to have_content project.owner.email
    end
  end
end
