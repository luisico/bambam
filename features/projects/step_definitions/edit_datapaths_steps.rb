### Methods

def fancytree_node(title)
  # TODO make sure these take advantage of capybara inherent waiting
  page.find('span.fancytree-title', text: title)
end

def fancytree_parent(node_title)
  fancytree_node(node_title).find(:xpath, '..')
end

### Given

Given /^there (is|are) (\d+|a) datapaths in that project$/ do |foo, n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)

  expect {
    @project_datapaths = FactoryGirl.create_list(:datapath, n, users: [@manager], projects: [@project])
  }.to change(Datapath, :count).by(n)
  @project_datapath = @project_datapaths.last
end

Given /^I have access to (\d+|a) additional datapaths$/ do |n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)

  expect {
    @datapaths = FactoryGirl.create_list(:datapath, n, users: [@manager])
  }.to change(Datapath, :count).by(n)
  @datapath = @datapaths.last
end

Given /^one of those additional datapaths has a sub\-directory$/ do
  @dir = 'dir1'
  @basename = 'subdir1'
  sub_dir = File.join(@datapath.path, @dir, @basename)
  Pathname.new(sub_dir).mkpath unless File.exist?(sub_dir)
end

Given /^one of those project datapaths has a sub\-directory$/ do
  sub_dir = FactoryGirl.create(:projects_datapath, project: @project, datapath: @project_datapath)
  @basename = Pathname.new(sub_dir.full_path).basename.to_s
end

### When

### Then

Then /^I should be able to add a datapath to the project$/ do
  expect {
    fancytree_parent(@datapath.path).find('span.fancytree-checkbox').click
    expect(fancytree_parent(@datapath.path)[:class]).to include 'fancytree-selected'

    # TODO sub below for module like in thoughbot post
    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.to change(@project.datapaths, :count).by(1)
end

Then /^I should be able to remove a datapath from the project$/ do
  expect {
    page.execute_script("$('span.fancytree-selected').last().children('.fancytree-checkbox').click()")
    expect(fancytree_parent(@project_datapath.path)[:class]).not_to include 'fancytree-selected'

    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.to change(@project.datapaths, :count).by(-1)
end

Then /^I should be able to add a sub\-directory to the project$/ do
  expect {
    fancytree_parent(@datapath.path).find('span.fancytree-expander').click
    fancytree_parent(@dir).find('span.fancytree-expander').click
    fancytree_parent(@basename).find('span.fancytree-checkbox').click

    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.to change(@project.datapaths, :count).by(1)
end

Then /^I should be able to remove a sub\-directory to the project$/ do
  expect {
    fancytree_parent(@basename).find('span.fancytree-checkbox').click
    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.to change(@project.datapaths, :count).by(-1)
end
