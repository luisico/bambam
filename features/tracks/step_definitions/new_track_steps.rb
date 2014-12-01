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

def link_to_add_track
  link = all('a', text: 'Add a track') || all('a', text: 'Add another track')
  raise 'Link to add a/another track not found' if link.empty?
  link.first
end

### Given

### When

When /^I create a track without a name$/ do
  expect{
    build_track
    link_to_add_track.click
    within('.new-record') {
      fill_track_form @track.merge(name: '')
    }
    click_button 'Update Project'
  }.not_to change(Track, :count)
end

When /^I create a track without a path$/ do
  expect{
    build_track
    link_to_add_track.click
    within('.new-record') {
      fill_track_form @track.merge(path: '')
    }
    click_button 'Update Project'
  }.not_to change(Track, :count)
end

When /^I click the "(.*?)" link$/ do |link|
  click_link link
end

When /^I delete a track before updating project$/ do
  build_track_with_path
  expect {
    link_to_add_track.click
    within('.new-record') {
      fill_track_form
      find('.remove-track').trigger('click')
    }
    click_button 'Update Project'
    @project.reload
  }.not_to change(@project.tracks, :count)
end

When /^I add a track to the project$/ do
  link_to_add_track.click
end

When /^I delete a track from the project$/ do
  find('.remove-track').trigger('click')
end

### Then

Then /^I should be able to add a track to the project$/ do
  build_track_with_path
  expect {
    link_to_add_track.click
    within('.new-record') {
      fill_track_form
    }
    click_button 'Update Project'
    @project.reload
  }.to change(@project.tracks, :count).by(1)
  expect(page).to have_css('.alert-box', text: 'Project was successfully updated')
end

Then /^I should be the owner of that track$/ do
  owner = (@user || @manager)
  expect(@project.tracks.first.owner).to eq owner
end

Then /^I should be on the track show page$/ do
  expect(current_path).to eq track_path(Track.last)
end


Then /^I should see instructions to use the allowed paths$/ do
  ENV['ALLOWED_TRACK_PATHS'].split(':').each do |path|
    expect(page).to have_content path
  end
end

Then /^the page should have the error can't be blank$/ do
  expect(page).to have_content "can't be blank"
end

Then /^I should not add a track to the project$/ do
  expect(Project.last.tracks.count).to eq(0)
  expect(page).to have_css('.alert-box', text: 'Nothing was changed in the project')
end
