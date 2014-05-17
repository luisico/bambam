### Methods

### Given

### When

When /^I click on the track edit link$/ do
  click_link 'Edit'
end

When /^I visit the edit track page$/ do
  visit edit_track_path(@track)
end

### Then

Then /^I should be on the edit track page$/ do
  expect(page).to have_content 'Edit track'
end

Then /^I should be able to edit the track name$/ do
  expect {
    fill_in 'Track name', with: 'new_track_name'
    click_button 'Update'
    @track.reload
  }.to change(@track, :name)
  expect(page).to have_css('.alert-box', text: 'Track was successfully updated')
end

Then /^I should be able to edit the track path$/ do
  path = File.join 'tmp', 'tests', 'new_track_path'
  FileUtils.mkdir(File.join('tmp', 'tests')) if !File.exist?(File.join('tmp', 'tests'))
  File.open(path, 'w') {|f| f.puts 'file content' }
  expect {
    fill_in 'Full path to track', with: path
    click_button 'Update'
    @track.reload
  }.to change(@track, :path)
  expect(page).to have_css('.alert-box', text: 'Track was successfully updated')
end
