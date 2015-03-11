### Methods

def delete_track(track_title)
  fancytree_parent(track_title).find('span.fancytree-checkbox').click
  loop until page.evaluate_script('jQuery.active').zero?
end

### Given

### When

### Then

Then /^I should( not)? be able to delete a track from the project$/ do |negate|
  track_title = Pathname.new(@track.full_path).basename.to_s
  if negate
    within(fancytree_parent(track_title)){
      expect(page).to have_css 'span.fancytree-title'
      expect(page).not_to have_css 'span.fancytree-checkbox'
    }
  else
    expect{
      delete_track(track_title)
      @project.reload
    }.to change(@project.tracks, :count).by(-1)
  end
end

# Then /^I should( not)? be able to delete a track from the track edit panel$/ do |negate|
#   if negate
#     expect(page).not_to have_link deleted_track_name
#   else
#     click_link deleted_track_name
#     delete_track(deleted_track_name)
#   end
# end

# Then /^I should be able to delete tracks from the project$/ do
#   deleted_tracks = Track.all[0..1]
#   expect {
#     find('.track-form-group')[0..1].each do |track_group|
#       find('.remove-track').trigger('click')
#     end
#     click_button 'Update'
#     @project.reload
#   }.to change(@project.tracks, :count).by(-2)
#   expect(current_path).to eq project_path(@project)
#   deleted_tracks.each do |track|
#     expect(@project.tracks).not_to include(track)
#     expect(page).not_to have_content(track)
#   end
#   expect(@project.tracks).to include(Track.last)
#   expect(page).to have_content Track.last.name
# end


# Then /^I should be able to restore a deleted track$/ do
#   expect {
#     track_group = first('.track-form-group')
#     within(track_group) {
#       find('.remove-track').trigger('click')
#       expect(page).to have_css('.line-through')
#       find('.restore-track').trigger('click')
#       expect(page).not_to have_css('.line-through')
#     }
#     click_button 'Update'
#     @project.reload
#   }.not_to change(@project.tracks, :count)
# end

# Then /^I should not be able to edit a deleted track$/ do
#   track_group = first('.track-form-group')
#   within(track_group) {
#     find('.remove-track').trigger('click')
#     expect(page).not_to have_css('.edit-track')
#   }
# end
