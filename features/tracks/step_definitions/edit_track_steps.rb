### Methods
def build_track_path
  @path = File.join 'tmp', 'tests', 'new_track_path.bam'
  FileUtils.mkdir(File.join('tmp', 'tests')) if !File.exist?(File.join('tmp', 'tests'))
  File.open(@path, 'w') {|f| f.puts 'file content' }
end

### Given

### When

### Then

Then /^I should be to udpate the track name$/ do
  @track = @project.tracks.first
  expect {
    click_link @track.name
    execute_script %Q{$('.track-form-group .track-form-fields').show();}
    fill_in 'project[tracks_attributes][0][name]', with: 'new_track_name'
    click_button 'Update'
    @track.reload
  }.to change(@track, :name)
  expect(page).to have_css('.alert-box', text: 'Project was successfully updated')
end

Then /^I should be to udpate the track path$/ do
  build_track_path
  track = @project.tracks.first
  expect {
    click_link track.name
    fill_in 'project[tracks_attributes][0][path]', with: @path
    click_button 'Update'
    track.reload
  }.to change(track, :path)
  expect(page).to have_css('.alert-box', text: 'Project was successfully updated')
end

Then /^I should( not)? be able to change the track's project$/ do |negate|
  track = @project.tracks.first
  if negate
    click_link track.name
    expect(page).not_to have_content "Assign track to a project"
  else
    expect {
      click_link track.name
      select "#{Project.first.name}", from: "Assign track to a project"
      click_button 'Update'
      track.reload
    }.to change(track, :project_id)
    expect(page).to have_css('.alert-box', text: 'Project was successfully updated')
  end
end

Then /^the track project should not change$/ do
  expect(@track.project).to eq(@project)
end
