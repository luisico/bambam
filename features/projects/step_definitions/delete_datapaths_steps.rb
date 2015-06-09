### When

### Then

Then /^I should be able to remove a datapath from the project$/ do
  expect {
    select_node(@projects_datapath.full_path)
    expect(fancytree_parent(@projects_datapath.full_path)[:class]).not_to include 'fancytree-selected'

    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.to change(@project.datapaths, :count).by(-1)
end

Then /^I should be able to remove the datapath sub\-directory from the project$/ do
  expect {
    select_node(@basename)
    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.to change(@project.datapaths, :count).by(-1)
end

Then /^I should be informed of a failed datapath deletion$/ do
  allow_any_instance_of(ProjectsDatapath).to receive(:destroy).and_return(false)
  expect {
    select_node(@projects_datapath.full_path)
    loop until page.evaluate_script('jQuery.active').zero?
  }.not_to change(ProjectsDatapath, :count)

  expect(fancytree_parent(@projects_datapath.full_path)[:class]).to include 'error-red'
end