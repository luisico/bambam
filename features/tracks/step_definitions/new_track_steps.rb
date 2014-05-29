### Methods

def build_track
  @track ||= FactoryGirl.attributes_for(:test_track)
end

def build_track_with_path
  build_track
  path = @track[:path]
  FileUtils.mkdir(File.dirname(path)) if !File.exist?(File.dirname(path))
  File.open(path, 'w') {|f| f.puts 'file content' }
 end

def fill_track_form(track=nil)
  track ||= @track
  fill_in 'Track name', with: track[:name]
  fill_in 'Full path to track', with: track[:path]
  click_button 'Create Track'
end

### Given

Given /^I am on the new track page$/ do
  visit new_track_path
end

### When

When /^I follow the new track link$/ do
  click_link 'New Track'
end

When /^I create a new track$/ do
  expect{
    build_track_with_path
    fill_track_form
  }.to change(Track, :count).by(1)
end

When /^I create a track without a name$/ do
  expect{
    build_track
    fill_track_form @track.merge(name: '')
  }.to change(Track, :count).by(0)
end

When /^I create a track without a path$/ do
  expect{
    build_track
    fill_track_form @track.merge(path: '')
  }.to change(Track, :count).by(0)
end

### Then

Then /^I should be on the new track page$/ do
  expect(page).to have_content 'New track'
end

Then /^I should be on the track show page$/ do
  expect(current_path).to eq track_path(Track.last)
end

Then /^I should see a message that the track was created successfully$/ do
  expect(page).to have_content('Track was successfully created')
end

Then /^I should see instructions to use the allowed paths$/ do
  ENV['ALLOWED_TRACK_PATHS'].split(':').each do |path|
    expect(page).to have_content path
  end
end
