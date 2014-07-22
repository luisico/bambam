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
  }.not_to change(Track, :count)
end

When /^I create a track without a path$/ do
  expect{
    build_track
    click_link 'Add Track'
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
    click_link 'Add Track'
    expect(page).to have_link 'Add another track'
    within('.new-record') {
      fill_track_form
      find('.remove-track').trigger('click')
    }
    expect(page).to have_link 'Add Track'
    click_button 'Update Project'
    @project.reload
  }.not_to change(@project.tracks, :count)
end

### Then

Then /^I should be able to add a track to the project$/ do
  if @project.tracks.any?
    link = 'Add another track'
  else
    link = 'Add Track'
  end
  build_track_with_path
  expect {
    click_link link
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

Then /^the page should have the error can't be blank$/ do
  expect(page).to have_content "can't be blank"
end

Then /^I should not add a track to the project$/ do
  expect(Project.last.tracks.count).to eq(0)
  expect(page).to have_css('.alert-box', text: 'Nothing was changed in the project')
end
