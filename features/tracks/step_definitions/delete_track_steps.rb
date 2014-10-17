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

Then /^I should be able to delete tracks from the project$/ do
  deleted_tracks = Track.all[0..1]
  expect {
    find('.track-form-group')[0..1].each do |track_group|
      find('.remove-track').trigger('click')
    end
    click_button 'Update'
    @project.reload
  }.to change(@project.tracks, :count).by(-2)
  expect(current_path).to eq project_path(@project)
  deleted_tracks.each do |track|
    expect(@project.tracks).not_to include(track)
    expect(page).not_to have_content(track)
  end
  expect(@project.tracks).to include(Track.last)
  expect(page).to have_content Track.last.name
end


Then /^I should be able to restore a deleted track$/ do
  expect {
    track_group = first('.track-form-group')
    within(track_group) {
      find('.remove-track').trigger('click')
      expect(page).to have_css('.line-through')
      find('.restore-track').trigger('click')
      expect(page).not_to have_css('.line-through')
    }
    click_button 'Update'
    @project.reload
  }.not_to change(@project.tracks, :count)
end
