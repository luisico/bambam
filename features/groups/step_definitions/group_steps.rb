### Methods

### Given

Given /^I own (\d+|a) groups?$/ do |n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)
  user = User.last
  @groups = FactoryGirl.create_list(:group, n, owner: user)
  @group = Group.last
end

Given /^I belong to (\d+|a) groups?$/ do |n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)
  user = User.last
  @groups = FactoryGirl.create_list(:group, n, members: [user])
end

Given /^there (is|are) (\d+|a) groups? in the system$/ do |foo, n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)
  user = FactoryGirl.create(:user)

  expect {
    FactoryGirl.create_list(:group, n, owner: user)
  }.to change(Group, :count).by(n)
  @group = Group.last
end

Given /^there are (\d+) additional members of that group$/ do |number|
  @group ||= @groups.last
  FactoryGirl.create_list(:user, number.to_i, groups: [@group])
end

### When

### Then
