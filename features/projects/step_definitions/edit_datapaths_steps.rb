### Methods

### Given

### When

### Then

Then /^I should be able to immediately remove the datapath$/ do
  expect {
    select_node(@datapath.path)
    expect(fancytree_parent(@datapath.path)[:class]).not_to include 'fancytree-selected'

    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.to change(@project.datapaths, :count).by(-1)
end
