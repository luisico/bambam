### Methods

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
