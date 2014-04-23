### Methods

### Given

Given /^there (is|are) (\d+|a|an) tracks? in the system$/ do |foo, n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)
  
  expect {
    FactoryGirl.create_list(:track, n)
  }.to change(Track, :count).by(n)
  @track = Track.last
end

### When

When /^I am on the tracks page$/ do
  visit tracks_path
end

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
