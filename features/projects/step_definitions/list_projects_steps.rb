### Methods

### Given

Given /^there (is|are) (\d+|a|an) projects? in the system$/ do |foo, n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)

  expect {
    @projects = FactoryGirl.create_list(:project, n)
  }.to change(Project, :count).by(n)
  @project = Project.last
end

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
  @projects.each do |project|
    expect(page).not_to have_content project.name
  end
end
