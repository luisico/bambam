### Methods

### Given

Given /^I own (\d+|a) projects?$/ do |n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)
  admin = User.last
  expect(admin.has_role? :admin).to eq(true)
  expect {
    @projects = FactoryGirl.create_list(:project, n, owner: admin)
  }.to change(Project, :count).by(n)
  @project = Project.last
end

Given /^I belong to (\d+|a) projects?$/ do |n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)
  user = User.last
  expect {
    @projects = FactoryGirl.create_list(:project, n, users: [user])
  }.to change(Project, :count).by(n)
  @project = Project.last

end

Given /^there (is|are) (\d+|a) projects? in the system$/ do |foo, n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)
  user = FactoryGirl.create(:user)

  expect {
    FactoryGirl.create_list(:project, n, owner: user)
  }.to change(Project, :count).by(n)
  @project = Project.last
end

Given /^there are (\d+) additional users of that project$/ do |n|
  @project ||= @projects.last
  FactoryGirl.create_list(:user, n.to_i, :projects => [@project])
end

### When

### Then

