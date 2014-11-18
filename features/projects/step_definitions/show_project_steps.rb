### Methods

### Given

### When

When /^I am on the project page$/ do
  visit project_path(@project)
end

### Then

Then /^I should be on the project page$/ do
  expect(current_path).to eq project_path(@project)
end

Then /^I should see the project's name$/ do
  expect(page).to have_content @project.name
end

Then /^I should see the project's tracks$/ do
  project = @project || Project.last
  project.tracks.each do |track|
    expect(page).to have_link track.name
    expect(page).to have_selector(:xpath, "//a[contains(@href, 'http://localhost:60151/load') and text()='igv']")
  end
end

Then /^I should see the project's users with(out)? profile links$/ do |negate|
  @project ||= Project.last
  if negate
    @project.users.each do |user|
      within("#user-#{user.id}") do
        if user != @user
          expect(page).to have_content user.handle
          expect(page).not_to have_link user.handle
        else
          expect(page).to have_link user.handle
        end
      end
    end
  else
    @project.users.each do |user|
      within("#user-#{user.id}") do
        expect(page).to have_link user.handle
      end
    end
  end
end

Then /^I should see the project's owner$/ do
  project = @project || Project.last
  within("#user-#{project.owner.id}") do
    expect(page).to have_css('.admin-icon')
  end
end

Then /^I should be on the tracks page$/ do
  expect(current_path).to eq tracks_path
end
