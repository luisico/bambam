### Methods

### Given

### When

### Then

Then /^I should see a list of tracks$/ do
  expect(Track.count).to be > 0
  Track.all.each do |track|
    expect(page).to have_content track.name
  end
end

Then /^I should see links to open the tracks in IGV$/ do
  Track.all.each do |track|
    encoded = ERB::Util.url_encode stream_services_track_url(track)
    expect(page).to have_selector(:xpath, "//a[contains(@href, '#{encoded}') and text()='igv']")
  end
end
