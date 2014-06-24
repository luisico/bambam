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
  @user.projects.each do |project|
    expect(page).to have_content project.name
  end
  Project.all.keep_if{|p| p.owner != @user}.each do |project|
    expect(page).not_to have_content project.name
  end
end
