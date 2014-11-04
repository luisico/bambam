### Methods
def build_track_path
  @path = File.join 'tmp', 'tests', 'new_track_path.bam'
  FileUtils.mkdir(File.join('tmp', 'tests')) if !File.exist?(File.join('tmp', 'tests'))
  File.open(@path, 'w') {|f| f.puts 'file content' }
end

### Given

### When

### Then

Then /^I should be able to verify track properties$/ do
  track = @project.tracks.last
  click_link track.name
  within(find(".track-form-fields")) do
    expect(page).to have_select("project[tracks_attributes][0][project_id]", :selected => @track.project.name)
    expect(find_field('Name').value).to eq track.name
    expect(find_field('Path').value).to eq track.path
  end
end

Then /^I should be able to update the track name$/ do
  track = @project.tracks.first
  expect {
    click_link @track.name
    fill_in 'project[tracks_attributes][0][name]', with: 'new_track_name'
    click_link 'done'
    expect(page).to have_content 'new_track_name'
    click_button 'Update'
    track.reload
  }.to change(track, :name)
  expect(page).to have_css('.alert-box', text: 'Project was successfully updated')
end

Then /^I should be able to update the track path$/ do
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

Then /^I should( not)? see a border when I click "(.*?)"$/ do |negate, link|
  if negate
    click_link link
    expect(first('.track-form-group')[:class]).to eq "track-form-group"
  else
    click_link @track.name
    expect(first('.track-form-group')[:class]).to eq "track-form-group  edit-record"
  end
end
