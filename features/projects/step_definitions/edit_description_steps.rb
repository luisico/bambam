### Methods

### Given

### When

### Then

Then /^I should( not)? be able to edit the project description$/ do |negate|
  if negate
    within(page.find('#project-desc')) {
      expect(page).not_to have_css 'span.best_in_place'
    }
  else
    expect{
      bip_text(@project, :desc, 'new_desc')
      expect(page).to have_content 'new_desc'
      loop until page.evaluate_script('jQuery.active').zero?
      @project.reload
    }.to change(@project, :desc)
    expect(@project.desc).to eq 'new_desc'
  end
end

Then /^I should be able to set project description to blank$/ do
  expect{
    bip_text(@project, :desc, '')
    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.to change(@project, :desc)
end
