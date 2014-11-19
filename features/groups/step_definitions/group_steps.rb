### Methods

### Given

Given /^I own (\d+|a) groups?$/ do |n|
  group_owner = User.last
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)
  @groups = FactoryGirl.create_list(:group, n, owner: group_owner)
  @group = @groups.last
end

Given /^I belong to (\d+|a) groups?$/ do |n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)
  @groups = FactoryGirl.create_list(:group, n, members: [@user])
  @group = @groups.last
end

Given /^there (is|are) (\d+|a) groups? in the system$/ do |foo, n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)
  admin = FactoryGirl.create(:admin)

  expect {
    @groups = FactoryGirl.create_list(:group, n, owner: admin)
  }.to change(Group, :count).by(n)
  @group = Group.last
end

Given /^there are (\d+) additional members of that group$/ do |number|
  @group ||= @groups.last
  FactoryGirl.create_list(:user, number.to_i, groups: [@group])
end

### When

### Then
