### Methods

### Given

Given /^there is a (bam|bw) track in that project$/ do |type|
  @project ||= @projects.last
  if type == 'bam'
    @track = FactoryGirl.create(:test_track, project: @project)
    cp_track Pathname.new(@track.path).sub_ext('.bai'), 'bai'
  elsif type== 'bw'
    @track = FactoryGirl.create(:test_track, path: File.join("tmp", "tests", "bw_track.bw"), project: @project)
  end
end

### When

When /^I click on the track name$/ do
  click_link @track.name
  expect(current_path).to eq track_path(@track)
end

When /^I am on the track page$/ do
  visit track_path(@track)
end

When /^I click on the download (bam|bai|bw) track link$/ do |type|
  click_link "download #{type} file"
end

When /^I click on the "(.*?)" link$/ do |text|
  click_link text
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

Then /^I should see the track's project$/ do
  expect(page).to have_link @track.project.name
end

Then /^I should( not)? see a link to the track's owner$/ do |negate|
  if negate
    expect(page).to have_content @track.owner.handle
  else
    expect(page).to have_link @track.owner.handle
  end
end

Then /^I should see a link to open the track in IGV$/ do
  encoded = ERB::Util.url_encode stream_services_track_url(@track)
  expect(page).to have_selector(:xpath, "//a[contains(@href, '#{encoded}') and text()='igv']")
end

Then /^I should see a link to download a (bam|bw) file$/ do |type|
  expect(page).to have_link "download #{type} file"
end

Then /^I should( not)? see a "(.*?)" link$/ do |negate, text|
  if negate
    expect(page).not_to have_link text
  else
    expect(page).to have_link text
  end
end

Then /^a (bam|bai|bw) file should download$/ do |ext|
  filename = Pathname.new(@track.path).sub_ext(".#{ext}").basename.to_s
  expect(page.response_headers['Content-Disposition']).to eq "attachment; filename=\"#{filename}\""
end
