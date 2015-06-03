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

When /^I select the last additional datapath$/ do
  expect {
    select_node(@datapath.path)
    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.to change(@project.projects_datapaths, :count).by(-1)
  expect(@project.projects_datapaths.last.datapath).to eq @datapath
end

When /^I select the immediate parent of the first track$/ do
  expect {
    select_node("tracks")
    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.to change(@project.projects_datapaths, :count).by(1)
  expect(fancytree_parent("tracks")[:class]).to include 'fancytree-selected'
  expect(fancytree_parent(@projects_datapath.full_path)[:class]).not_to include 'fancytree-selected'
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

Then /^both of the child sub\-directories should not be selected$/ do
  expect(fancytree_parent(@basename)[:class]).not_to include 'fancytree-selected'
  expect(fancytree_parent(@basename2)[:class]).not_to include 'fancytree-selected'
end

Then /^the second track will be automatically transitioned$/ do
  @track2.reload
  expect(fancytree_parent("track_s2")[:class]).to include 'fancytree-selected'
  # TODO test below should pass but track doesn't appear to be updating
  # expect(@track2.projects_datapath_id).to eq @project.projects_datapaths.last.id
end
