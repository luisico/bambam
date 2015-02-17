### Methods

def fancytree_node(title)
  # TODO make sure these take advantage of capybara inherent waiting
  page.find('span.fancytree-title', text: title)
end

def fancytree_parent(node_title)
  fancytree_node(node_title).find(:xpath, '..')
end

def select_node(title)
  @title = title
  fancytree_parent(title).find('span.fancytree-checkbox').click
end

### Given

# TODO: nomenclatures: master datapath vs datapath vs datapath with subdir
Given /^there (is|are) (\d+|a) datapaths in that project$/ do |foo, n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)

  expect {
    @project_datapaths = FactoryGirl.create_list(:datapath, n, users:[@project.owner])
    @project_datapaths.each do |datapath|
      FactoryGirl.create(:projects_datapath, project: @project, datapath: datapath)
    end
  }.to change(Datapath, :count).by(n)
  @project_datapath = @project_datapaths.last
end

Given /^I have access to (\d+|a) additional datapaths$/ do |n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)

  expect {
    @datapaths = FactoryGirl.create_list(:datapath, n, users: [@project.owner])
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

Then /^I should( not)? be able to add a datapath to the project$/ do |negate|
  if negate
    expect(fancytree_parent(@datapath.path)).not_to have_css('span.fancytree-checkbox')
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

Then /^I should be informed of a failed datapath creation$/ do
  ProjectsDatapath.any_instance.stub(:valid?).and_return(false)
  select_node(@datapath.path)
  loop until page.evaluate_script('jQuery.active').zero?

  expect(fancytree_parent(@datapath.path)[:class]).to include 'error-red'
  expect(fancytree_parent(@datapath.path)[:class]).not_to include 'fancytree-selected'
end

Then /^I should be informed of a failed datapath deletion$/ do
  ProjectsDatapath.any_instance.stub(:valid?).and_return(false)
  select_node(@project_datapath.path)
  loop until page.evaluate_script('jQuery.active').zero?

  expect(fancytree_parent(@project_datapath.path)[:class]).to include 'error-red'
end

Then /^I should see the status code appended to the node title$/ do
  expect(fancytree_node(@title).text).to include '[Bad Request]'
end

Then /^I should be able to immediately remove the datapath$/ do
  expect {
    select_node(@datapath.path)
    expect(fancytree_parent(@datapath.path)[:class]).not_to include 'fancytree-selected'

    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.to change(@project.datapaths, :count).by(-1)
end
