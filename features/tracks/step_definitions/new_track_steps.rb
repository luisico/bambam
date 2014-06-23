### Methods

def build_track
  @track ||= FactoryGirl.attributes_for(:test_track)
end

def build_track_with_path
  build_track
  cp_track @track[:path]
 end

def fill_track_form(track=nil)
  track ||= @track
  fill_in 'Name', with: track[:name]
  fill_in 'Path', with: track[:path]
end

### Given

### When

When /^I create a track without a name$/ do
  expect{
    build_track
    click_link 'Add Track'
    within('.new-record') {
      fill_track_form @track.merge(name: '')
    }
    click_button 'Update Project'
  }.to change(Track, :count).by(0)
end

When /^I create a track without a path$/ do
  expect{
    build_track
    click_link 'Add Track'
    within('.new-record') {
      fill_track_form @track.merge(path: '')
    }
  }.to change(Track, :count).by(0)
end

When /^I click the "(.*?)" link$/ do |link|
  click_link link
end

### Then

Then /^I should be able to add a track to the project$/ do
  build_track_with_path
  expect {
    click_link 'Add Track'
    within('.new-record') {
      fill_track_form
    }
    click_button 'Update Project'
    @project.reload
  }.to change(@project.tracks, :count).by(1)
  expect(page).to have_css('.alert-box', text: 'Project was successfully updated')
end

Then /^I should be on the track show page$/ do
  expect(current_path).to eq track_path(Track.last)
end


Then /^I should see instructions to use the allowed paths$/ do
  ENV['ALLOWED_TRACK_PATHS'].split(':').each do |path|
    expect(page).to have_content path
  end
end
