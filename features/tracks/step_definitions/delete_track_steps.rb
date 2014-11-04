### Methods

def delete_track(track_name)
  expect {
    track_group = first('.track-form-group')
    within(track_group) {
      yield if block_given?
      find('.remove-track').trigger('click')
    }
    click_button 'Update'
    @project.reload
  }.to change(@project.tracks, :count).by(-1)
  expect(current_path).to eq project_path(@project)
  expect(page).not_to have_content(track_name)
end

### Given

### When

### Then

Then /^I should be able to delete a track from the project$/ do
  deleted_track_name = Track.first.name
  delete_track(deleted_track_name) do
    expect(page).to have_content deleted_track_name
  end
end

Then /^I should be able to delete a track from the track edit panel$/ do
  deleted_track_name = Track.first.name
  click_link deleted_track_name
  delete_track(deleted_track_name)
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

Then /^I should not be able to edit a deleted track$/ do
  track_group = first('.track-form-group')
  within(track_group) {
    find('.remove-track').trigger('click')
    expect(page).not_to have_css('.edit-track')
  }
end
