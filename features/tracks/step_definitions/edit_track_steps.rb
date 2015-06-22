### Methods

### Given

### When

When /^I select an invalid track parent directory$/ do
  allow_any_instance_of(Track).to receive(:update).and_return(false)
  select_node('tracks')
end

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

Then /^I should( not)? be able to update the track (.*?)$/ do |negate, attribute|
  if negate
    expect(page).not_to have_selector ".best_in_place[data-bip-attribute='#{attribute}']"
  else
    expect(page).to have_selector ".best_in_place[data-bip-attribute='#{attribute}']"
    new_value = "new_#{attribute}"
    expect {
      bip_text(@track, attribute, new_value)
      expect(page).to have_content new_value
      loop until page.evaluate_script('jQuery.active').zero?
      @track.reload
    }.to change(@track, attribute)
    expect(@track.send(attribute)).to eq new_value
  end
end

Then /^I should not be able to set track (.*?) to blank$/ do |attribute|
  expect {
    bip_text(@track, attribute, '')
    expect(page).to have_css 'small.error', text: I18n.t('errors.messages.blank')
    loop until page.evaluate_script('jQuery.active').zero?
    @track.reload
  }.not_to change(@track, attribute)
end

Then /^I should be able to change the track (.*?) to "(.*?)"$/ do |attribute, new_value|
  expect {
    bip_text(@track, attribute, new_value)
    expect(page).to have_content new_value
    loop until page.evaluate_script('jQuery.active').zero?
    @track.reload
  }.to change(@track, attribute)
  expect(@track.send(attribute)).to eq new_value
end

Then /^the IGV link should be updated with a new (.*?)$/ do |attribute|
   igv_url = find('a.fi-eye')[:href]
   params = igv_url.split('?')[1].split('&')
   attr_index = params.index{|x| x.include? attribute + '='}

   expect(params[attr_index]).to eq URI::Generic.build(:query => {attribute => @track.send(attribute)}.to_query).to_s.gsub(/^\?/, '')
end
