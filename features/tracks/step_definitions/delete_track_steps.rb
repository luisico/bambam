### Methods

### Given

### When

### Then

Then /^I should be able to delete a track from the project$/ do
  deleted_track = Track.first.name
  expect {
    track_group = first('.track-form-group')
    within(track_group) {
      expect(track_group).to have_content deleted_track
      find('.remove-track').trigger('click')
    }
    click_button 'Update'
    @project.reload
  }.to change(@project.tracks, :count).by(-1)
  expect(current_path).to eq project_path(@project)
  expect(page).not_to have_content(deleted_track)
end
