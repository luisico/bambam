### Methods

### Given

### When

When /^I click on the project name$/ do
  click_link @project.name
end

When /^I am on the project page$/ do
  visit project_path(@project)
end

### Then

Then /^I should be on the show project page$/ do
  expect(current_path).to eq project_path(@project)
end

Then /^I should see the project's name$/ do
  expect(page).to have_content @project.name
end

Then /^I should see the projects tracks$/ do
  @project.tracks.each do |track|
    expect(page).to have_content track.name
    encoded = ERB::Util.url_encode stream_services_track_url(track)
    expect(page).to have_selector(:xpath, "//a[contains(@href, '#{encoded}') and text()='igv']")
  end
end

Then /^I should see the project's users with(out)? profile links$/ do |negate|
  if negate
    @project.users.each do |user|
      within("#project-user-#{user.id}") do
        expect(page).to have_content user.email
        expect(page).not_to have_link user.email
      end
    end
  else
    @project.users.each do |user|
      within("#project-user-#{user.id}") do
        expect(page).to have_link user.email
      end
    end
  end
end

Then /^I should see the project's creation date$/ do
  expect(page).to have_selector "time[data-local='time-ago'][datetime='#{@project.created_at.utc.iso8601}']"
end

Then /^I should see the date of the project's last update$/ do
  expect(page).to have_selector "time[data-local='time-ago'][datetime='#{@project.updated_at.utc.iso8601}']"
end

Then /^I should( not)? see a delete button$/ do |negate|
  if negate
    expect(page).not_to have_link 'Delete'
  else
    expect(page).to have_link 'Delete'
  end
end
