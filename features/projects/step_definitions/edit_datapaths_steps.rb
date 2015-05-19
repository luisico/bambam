### Methods

### Given

### When

When /^I select the parent datapath$/ do
  expect {
    select_node(@datapath.path)
    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.not_to change(@project.projects_datapaths, :count)
  expect(@project.projects_datapaths.last.datapath).to eq @datapath
  expect(@project.projects_datapaths.where(sub_directory: File.join(@dir, @basename))).to eq []
end

When /^I select the sub\-directory$/ do
  expect {
    select_node(@basename)
    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.not_to change(@project.datapaths, :count)
  expect(@project.projects_datapaths.last.sub_directory).to eq File.join @dir, @basename
  expect(@project.projects_datapaths).not_to include @datapath
end

### Then

Then /^I should be able to immediately remove the datapath$/ do
  expect {
    select_node(@datapath.path)
    expect(fancytree_parent(@datapath.path)[:class]).not_to include 'fancytree-selected'

    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.to change(@project.datapaths, :count).by(-1)
end

Then /^the parent datapath should( not)? be selected$/ do |negate|
  if negate
    expect(fancytree_parent(@datapath.path)[:class]).not_to include 'fancytree-selected'
  else
    expect(fancytree_parent(@datapath.path)[:class]).to include 'fancytree-selected'
  end
end

Then /^the sub\-directory should( not)? be selected$/ do |negate|
  if negate
    expect(fancytree_parent(@basename)[:class]).not_to include 'fancytree-selected'
  else
    expect(fancytree_parent(@basename)[:class]).to include 'fancytree-selected'
  end
end
