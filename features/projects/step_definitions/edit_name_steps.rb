### Methods

### Given

### When

### Then

Then /^I should( not)? be able to edit the project name$/ do |negate|
  if negate
    within(page.find('#project-name')) {
      expect(page).not_to have_css 'span.best_in_place'
    }
  else
    expect{
      bip_text(@project, :name, 'new_name')
      expect(page).to have_content 'new_name'
      loop until page.evaluate_script('jQuery.active').zero?
      @project.reload
    }.to change(@project, :name)
    expect(@project.name).to eq 'new_name'
  end
end

Then /^I should not be able to set project name to blank$/ do
  expect{
    bip_text(@project, :name, '')
    expect(page).to have_css 'small.error', text: I18n.t('errors.messages.blank')
    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.not_to change(@project, :name)
end

Then /^I should not be able to set project name to more than (\d+) characters$/ do |n|
  too_long_string = "s" * (n.to_i + 1)
  expect{
    bip_text(@project, :name, too_long_string)
    expect(page).to have_css 'small.error', text: "Application error."
    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.not_to change(@project, :name)
end
