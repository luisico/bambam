### Methods

### Given

### When

When /^I am on the tracks page$/ do
  visit tracks_path
end

When /^I click the play icon next to the project name$/ do
  find('.by-icon').click
end

When /^I filter tracks on "(.*?)"$/ do |track_filter|
  fill_in 'Filter tracks', with: track_filter
  click_button 'Filter'
  loop until page.evaluate_script('jQuery.active').zero?
  @track_filter = track_filter
end

### Then

Then /^I should see a list of tracks with IGV link grouped by project$/ do
  expect(Track.count).to be > 0
  Track.all.group_by{|track| track.project}.each do |project, track_array|
    expect(page).to have_link(project.name)
    expect(page).to have_content("#{track_array.length}")
    track_array.each do |track|
      expect(page).to have_link track.name
      encoded = ERB::Util.url_encode stream_services_track_url(track)
      expect(page).to have_selector(:xpath, "//a[contains(@href, '#{encoded}') and text()='igv']")
    end
  end
end

Then /^I should see a link to each track's project$/ do
  track_count = @project.tracks.count
  expect(page).to have_content(@project.name, count: track_count)
end

Then /^I should( not)? see a link to each track's owner$/ do |negate|
  @project.tracks.each do |track|
    if negate
      expect(page).to have_content track.owner.handle
    else
      expect(page).to have_link track.owner.handle
    end
  end
end

Then /^I should be able to access the track page from a link$/ do
  click_link @track.name
  expect(current_path).to eq track_path(@track)
end

Then /^I should see instuctions with a link to email an administrator$/ do
  expect(page).to have_link ENV['ADMIN_EMAIL']
end

Then /^I should see instuctions with a link to the projects page$/ do
  expect(page).to have_link 'projects'
end

Then /^I should see (\d+) tracks on the index page$/ do |count|
  track_count = page.all('.service.fi-eye').count
  expect(track_count).to eq count.to_i
end

Then /^I should see (\d+|no) text highlights?$/ do |count|
  count = (count == "no" ? 0 : count.to_i)

  highlight_count = page.all('span.highlight').count
  expect(highlight_count).to eq count.to_i
end

Then /^I should see a no tracks matched message$/ do
  expect(page).to have_content 'No tracks found.'
end
