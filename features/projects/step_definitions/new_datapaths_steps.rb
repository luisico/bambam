### Methods

### Given

### When

### Then

Then /^I should( not)? be able to add a datapath to the project$/ do |negate|
  if negate
    expect(page).not_to have_css('span.fancytree-title', text: @datapath.path)
  else
    expect {
      select_node(@datapath.path)
      # TODO sub below for module like in thoughbot post
      loop until page.evaluate_script('jQuery.active').zero?
      expect(fancytree_parent(@datapath.path)[:class]).to include 'fancytree-selected'

      @project.reload
    }.to change(@project.datapaths, :count).by(1)
  end
end

Then /^I should be able to add the datapath sub\-directory to the project$/ do
  expect {
    fancytree_parent(@datapath.path).find('span.fancytree-expander').click
    fancytree_parent(@dir).find('span.fancytree-expander').click
    fancytree_parent(@basename).find('span.fancytree-checkbox').click

    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.to change(@project.datapaths, :count).by(1)
end

Then /^I should be informed of a failed datapath addition$/ do
  ProjectsDatapath.any_instance.stub(:valid?).and_return(false)
  expect {
    select_node(@datapath.path)
    loop until page.evaluate_script('jQuery.active').zero?
  }.not_to change(ProjectsDatapath, :count)

  parent = fancytree_parent(@datapath.path)

  expect(parent[:class]).to include 'error-red'
  expect(parent[:class]).not_to include 'fancytree-selected'
end
