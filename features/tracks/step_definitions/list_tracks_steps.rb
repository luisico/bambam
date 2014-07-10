### Methods

### Given

### When

When /^I am on the tracks page$/ do
  visit tracks_path
end

### Then

Then /^I should see a list of tracks with IGV link$/ do
  expect(Track.count).to be > 0
  Track.all.each do |track|
    expect(page).to have_link track.name
    encoded = ERB::Util.url_encode stream_services_track_url(track)
    expect(page).to have_selector(:xpath, "//a[contains(@href, '#{encoded}') and text()='igv']")
    expect(page).to have_link track.project.name
  end
end

Then /^I should be able to access the track page from a link$/ do
  click_link @track.name
  expect(current_path).to eq track_path(@track)
end

Then /^I should see instuctions on how to add tracks$/ do
  expect(page).to have_content 'You either have no projects or no tracks'
end
