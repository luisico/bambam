### Methods

### Given

### When

When /^I click on the track name$/ do
  click_link @track.name
end

When /^I am on the track page$/ do
  visit track_path(@track)
end

### Then

Then /^I should be on the show track page$/ do
  expect(current_path).to eq track_path(@track)
end

Then /^I should see the track's name$/ do
  expect(page).to have_content @track.name
end

Then /^I should see the track's path$/ do
  expect(page).to have_content @track.path
end

Then /^I should see the track's creation date$/ do
  expect(page).to have_selector "time[data-local='time-ago'][datetime='#{@track.created_at.utc.iso8601}']"
end

Then /^I should see the date of the track's last update$/ do
  expect(page).to have_selector "time[data-local='time-ago'][datetime='#{@track.updated_at.utc.iso8601}']"
end

Then /^I should be able to acess the track page from a link$/ do
  click_link @track.name
  expect(current_path).to eq track_path(@track)
end

Then /^I should see a link to open the track in IGV$/ do
  encoded = ERB::Util.url_encode stream_services_track_url(@track)
  expect(page).to have_selector(:xpath, "//a[contains(@href, '#{encoded}') and text()='Open in IGV']")
end
