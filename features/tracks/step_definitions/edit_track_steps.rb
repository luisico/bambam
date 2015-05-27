### Methods
# def build_track_path
#   @path = File.join 'tmp', 'tests', 'new_track_path.bam'
#   FileUtils.mkdir(File.join('tmp', 'tests')) if !File.exist?(File.join('tmp', 'tests'))
#   File.open(@path, 'w') {|f| f.puts 'file content' }
# end

### Given

### When

### Then

Then /^the tracks? should be transitioned to the selected datapath$/ do
  @project.tracks.each do |track|
    expect(track.projects_datapath.full_path).to eq @datapath.path
  end
end

Then /^the track should be transitioned to the selected sub\-directory$/ do
  @project.tracks.each do |track|
    expect(track.projects_datapath.full_path).to eq File.join @datapath.path, @dir, @basename
  end
end

Then /^I should( not)? be able to update the track name$/ do |negate|
  if negate
    within(page.find('#track-name')) {
      expect(page).not_to have_css 'span.best_in_place'
    }
  else
    expect{
      bip_text(@track, :name, 'new_name')
      expect(page).to have_content 'new_name'
      loop until page.evaluate_script('jQuery.active').zero?
      @track.reload
    }.to change(@track, :name)
    expect(@track.name).to eq 'new_name'
  end
end

Then /^I should not be able to set track name to blank$/ do
  expect{
    bip_text(@track, :name, '')
    expect(page).to have_css 'small.error', text: I18n.t('errors.messages.blank')
    loop until page.evaluate_script('jQuery.active').zero?
    @track.reload
  }.not_to change(@track, :name)
end

# Then /^I should be able to verify track properties$/ do
#   track = @project.tracks.last
#   click_link track.name
#   within(find(".track-form-fields")) do
#     expect(page).to have_select("project[tracks_attributes][0][project_id]", selected: @track.project.name)
#     expect(find_field('Name').value).to eq track.name
#     expect(find_field('Path').value).to eq track.path
#   end
# end

# Then /^I should( not)? be able to update the track name$/ do |negate|
#   track = @project.tracks.first
#   if negate
#     expect(page).not_to have_link @track.name
#   else
#     expect {
#       click_link @track.name
#       fill_in 'project[tracks_attributes][0][name]', with: 'new_track_name'
#       click_link 'done'
#       expect(page).to have_content 'new_track_name'
#       click_button 'Update'
#       track.reload
#     }.to change(track, :name)
#     expect(page).to have_css('.alert-box', text: 'Project was successfully updated')
#   end
# end

# Then /^the track owners should not change$/ do
#   expect(@track.owner).not_to eq @admin
# end

# Then /^I should( not)? be able to update the track path$/ do |negate|
#   track = @project.tracks.first
#   if negate
#     expect(page).not_to have_link track.name
#   else
#     build_track_path
#     expect {
#       click_link track.name
#       fill_in 'project[tracks_attributes][0][path]', with: @path
#       click_button 'Update'
#       track.reload
#     }.to change(track, :path)
#     expect(page).to have_css('.alert-box', text: 'Project was successfully updated')
#   end
# end

# Then /^I should( not)? be able to change the track's project$/ do |negate|
#   track = @project.tracks.first
#   if negate
#     click_link track.name
#     expect(page).not_to have_content "Assign track to a project"
#   else
#     expect {
#       click_link track.name
#       select "#{Project.first.name}", from: "Assign track to a project"
#       click_button 'Update'
#       track.reload
#     }.to change(track, :project_id)
#     expect(page).to have_css('.alert-box', text: 'Project was successfully updated')
#   end
# end

# Then /^I should( not)? see a border when I click "(.*?)"$/ do |negate, link|
#   if negate
#     click_link link
#     expect(first('.track-form-group')[:class]).to eq "track-form-group"
#   else
#     click_link @track.name
#     expect(first('.track-form-group')[:class]).to eq "track-form-group  edit-record"
#   end
# end
