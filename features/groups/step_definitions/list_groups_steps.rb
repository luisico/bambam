### Methods

### Given

### When

### Then

Then /^I should see a list of all groups$/ do
  expect(Group.count).to be > 0
  Group.all.each do |group|
    expect(page).to have_content "#{group.name} owned by #{group.owner.email}"
  end
end

Then /^I should only see a list of groups I am a member of$/ do
  expect(Group.count).to be > 0
  Group.all.each do |group|
    text = "#{group.name} owned by #{group.owner.email}"
    if group.members.include?(@user)
      expect(page).to have_content text
    else
      expect(page).not_to have_content text
    end
  end
end


