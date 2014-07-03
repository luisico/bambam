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

Then /^I should only see a list of projects I belong to$/ do
  expect(Project.count).to be > 0
  Project.all.each do |project|
    if project.users.include?(@user)
      expect(page).to have_css "#project_#{project.id}"
      within("#project_#{project.id}") do
        expect(page).to have_content project.name
        expect(page).to have_content project.tracks.count
        expect(page).to have_content project.owner.email
        expect(page).not_to have_link project.owner.email
        expect(page).to have_selector "time[data-local='time-ago'][datetime='#{project.updated_at.utc.iso8601}']"
      end
    else
      expect(page).not_to have_css "#project_#{project.id}"
    end
  end
end
