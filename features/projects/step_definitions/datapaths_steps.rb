### Methods

def fancytree_node(title)
  # TODO make sure these take advantage of capybara inherent waiting
  page.find('span.fancytree-title', text: title)
end

def fancytree_parent(node_title)
  fancytree_node(node_title).find(:xpath, '../../..')
end

def select_node(title)
  @title = title
  fancytree_parent(title).find('span.fancytree-checkbox').click
end

def expand_node(title)
  fancytree_parent(title).find('span.fancytree-expander').click
end

### Given

Given /^there (is|are) (\d+|a) datapaths? in that project?$/ do |foo, n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)

  expect {
    owner_datapaths = FactoryGirl.create_list(:datapath, n, users:[@project.owner])
    @projects_datapaths = owner_datapaths.collect do |datapath|
      FactoryGirl.create(:projects_datapath, project: @project, datapath: datapath, path: '')
    end
  }.to change(Datapath, :count).by(n)
  @projects_datapath = @projects_datapaths.last
end

Given /^the project owner has access to (\d+|a) additional datapaths$/ do |n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)

  expect {
    @datapaths = FactoryGirl.create_list(:datapath, n, users: [@project.owner])
  }.to change(Datapath, :count).by(n)
  @datapath = @datapaths.last
end

Given /^one of those additional datapaths has a sub\-directory$/ do
  @dir = 'my_dir'
  @basename = 'my_subdir'
  sub_dir = File.join(@datapath.path, @dir, @basename)
  Pathname.new(sub_dir).mkpath unless File.exist?(sub_dir)
end

Given /^there is a datapath sub\-directory in the project$/ do
  @dir = 'my_dir'
  @basename = 'my_subdir'
  expect {
    FactoryGirl.create(:projects_datapath, project: @project, datapath: @datapath, path: File.join(@dir, @basename))
  }.to change(@project.projects_datapaths, :count).by(1)
end

Given /^there is another datapath sub\-directory in the project$/ do
  @dir2 = 'dir2'
  @basename2 = 'subdir_2'
  expect {
    FactoryGirl.create(:projects_datapath, project: @project, datapath: @datapath, path: File.join(@dir2, @basename2))
  }.to change(@project.projects_datapaths, :count).by(1)
end

### When

### Then

Then /^I should( not)? see the datapath name$/ do |negate|
  if negate
    name = @projects_datapath.name
    within(fancytree_parent(@projects_datapath.full_path)) {
      expect(page).not_to have_css('td.projects-datapath-name', text: name)
    }
  else
    name = @datapath.path.split(File::SEPARATOR).pop
    within(fancytree_parent(@datapath.path)) {
      expect(page).to have_css('td.projects-datapath-name', text: name)
    }
  end
end

Then /^I should see "(.*?)" appended to the node title$/ do |error|
  expect(fancytree_node(@title).text).to include error
end
