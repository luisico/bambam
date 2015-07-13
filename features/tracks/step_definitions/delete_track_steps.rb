### Methods

### Given

### When

### Then

Then /^I should( not)? be able to delete a track from the track show page$/ do |negate|
  if negate
    expect(page).not_to have_link 'Delete'
  else
    project = @track.project
    expect {
      click_link 'Delete'
    }.to change(Track, :count).by(-1)
    expect(current_path).to eq project_path(project)
  end
end
