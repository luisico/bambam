### Methods

### Given

### When

### Then

Then /^I should see a list of all groups$/ do
  expect(Group.count).to be > 0
  Group.all.each do |group|
    within("#group_#{group.id}") do
      expect(page).to have_content group.name
      expect(page).to have_css('.fi-sheriff-badge')
      expect(page).to have_content group.owner.email
    end
  end
end

Then /^I should only see a list of groups I am a member of$/ do
  expect(Group.count).to be > 0
  Group.all.each do |group|
    text = "#{group.name} owned by #{group.owner.email}"
    if group.members.include?(@user)
      within("#group_#{group.id}") do
        expect(page).to have_content group.name
        expect(page).to have_css('.fi-sheriff-badge')
        expect(page).to have_content group.owner.email
      end
    else
      expect(page).not_to have_css("#group_#{group.id}")
    end
  end
end


