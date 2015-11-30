### Methods

### Given

Given /^there is a (bam|bw) track in that project$/ do |type|
  @project ||= @projects.last
  projects_datapath = FactoryGirl.create(:projects_datapath, project: @project)
  if type == 'bam'
    @track = FactoryGirl.create(:track, projects_datapath: projects_datapath)
    cp_track Pathname.new(@track.full_path).sub_ext('.bai'), 'bai'
  elsif type== 'bw'
    @track = FactoryGirl.create(:track, path: File.join("tmp", "tests", "bw_track.bw"), projects_datapath: projects_datapath)
  end
end


Given /^I have previously set a locus$/ do
  expect {
    @tracks_user = FactoryGirl.create(:tracks_user, track: @track, user: @user, locus: "chr1:1-185,503,660")
  }.to change(TracksUser, :count).by(1)
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

Then /^I should see the track's genome$/ do
  expect(page).to have_content @track.genome
end

Then /^I should see the track's path$/ do
  expect(page).to have_content @track.full_path
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

Then /^I should( not)? see a link to open track in embedded IGV$/ do |negate|
  if negate
    expect(page).not_to have_css ".igv-js-link"
  else
    expect(page).to have_css ".igv-js-link"
  end
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

Then /^I should be able to activate igv js viewer$/ do
  click_link 'igv (embedded)'
  sleep 1
  expect(page).to have_selector '.igv-track-label-span-base', text: @track.name
end

Then /^my track should be loaded to the last locus$/ do
  search_input = find_field('igv-js-search-input')
  expect(search_input.value).to eq @tracks_user.locus
end

Then /^any changes I make in the locus should be saved$/ do
  new_locus = "chr1:1-185,503,670"
  expect {
    fill_in 'igv-js-search-input', with: new_locus
    loop until page.evaluate_script('jQuery.active').zero?
    @tracks_user.reload
  }.to change(@tracks_user, :locus)
  expect(@tracks_user.locus).to eq new_locus
end
