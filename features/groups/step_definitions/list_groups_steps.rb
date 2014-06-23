### Methods

### Given

### When

When /^I am on the groups page$/ do
  visit groups_path
end

### Then

Then /^I should see a list of all groups$/ do
  expect(Group.count).to be > 0
  Group.all.each do |group|
    expect(page).to have_content "#{group.name} (owner: #{group.owner.email})"
  end
end

Then /^I should only see a list of groups I am a member of$/ do
  expect(Group.count).to be > 0
  Group.all.each do |group|
    if group.members.include?(@user)
      expect(page).to have_content "#{group.name} (owner: #{group.owner.email})"
    else
      expect(page).not_to have_content "#{group.name} (owner: #{group.owner.email})"
    end
  end
end


