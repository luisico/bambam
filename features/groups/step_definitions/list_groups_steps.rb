### Methods

### Given

Given /^there (is|are) (\d+|a|an) groups? in the system$/ do |foo, n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)

  expect {
    FactoryGirl.create_list(:group, n)
  }.to change(Group, :count).by(n)
  @group = Group.last
end

### When

When /^I am on the groups page$/ do
  visit groups_path
end

### Then

Then /^I should see a list of groups$/ do
  expect(Group.count).to be > 0
  Group.all.each do |group|
    expect(page).to have_content group.name
  end
end


