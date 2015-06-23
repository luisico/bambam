### Methods

### Given

### When

### Then

Then /^I should( not)? be able to edit the project description$/ do |negate|
  if negate
    within(page.find('.description-icon')) {
      expect(page).not_to have_css 'span.best_in_place'
    }
  else
    expect{
      bip_text(@project, :description, 'new_description')
      expect(page).to have_content 'new_description'
      loop until page.evaluate_script('jQuery.active').zero?
      @project.reload
    }.to change(@project, :description)
    expect(@project.description).to eq 'new_description'
  end
end

Then /^I should be able to set project description to blank$/ do
  expect{
    bip_text(@project, :description, '')
    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.to change(@project, :description)
end
