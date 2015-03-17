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

Then /^I should be able to immediately delete the track$/ do
  expect {
    select_node(@track_title)
    expect(fancytree_parent(@track_title)[:class]).not_to include 'fancytree-selected'

    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.to change(@project.tracks, :count).by(-1)
end

# Then /^I should( not)? be able to delete a track from the track edit panel$/ do |negate|
#   if negate
#     expect(page).not_to have_link deleted_track_name
#   else
#     click_link deleted_track_name
#     delete_track(deleted_track_name)
#   end
# end
