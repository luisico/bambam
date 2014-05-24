### Methods

### Given

Given /^there is a (\.bam|\.bw) track in the system$/ do |type|
  if type == '.bam'
    @track = FactoryGirl.create(:test_track)
    File.open(Pathname.new(@track.path).sub_ext('bai'), 'w') {|f| f.puts '.bam file index'}
  elsif type== '.bw'
    @track = FactoryGirl.create(:test_track, path: File.join("tmp", "tests", "bw_track.bw"))
  end
end

### When

When /^I click on the track name$/ do
  click_link @track.name
end

When /^I am on the track page$/ do
  visit track_path(@track)
end

When /^I click on the download (\.bam|\.bw) track link$/ do |type|
  click_link "Download #{type} file"
end

When /^I click on the "(.*?)" link$/ do |index|
  click_link index
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

Then /^I should see a text with the track line for UCSC$/ do
  expect(page).to have_content "bigDataUrl="
end

Then /^I should see a link to download a (\.bam|\.bw) file$/ do |type|
  expect(page).to have_link "Download #{type} file"
end

Then /^I should( not)? see a "(.*?)" link$/ do |negate, index|
  if negate
    expect(page).not_to have_link index
  else
    expect(page).to have_link index
  end
end

Then /^a file should download$/ do
   expect(page.response_headers['Content-Type']).to eq "text/plain"
end

Then /^an index file should download$/ do
  expect(page.response_headers['Content-Type']).to eq "text/html; charset=utf-8"
end
