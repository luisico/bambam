### Methods

### Given

### When

When /^I click on the group name$/ do
  click_link @group.name
end

When /^I am on the group page$/ do
  visit group_path(@group)
end

### Then

Then /^I should be on the show group page$/ do
  expect(current_path).to eq group_path(@group)
end

Then /^I should see the group's name$/ do
  expect(page).to have_content @group.name
end

Then /^I should see the group's owner$/ do
  expect(page).to have_content "#{@group.owner.handle} (owner)"
end

Then /^I should see the group's members( with links)?$/ do |links|
  expect(@group.members.count).to be > 0
  within('#members') do
    @group.members.each do |member|
      expect(page).to have_xpath("//img[@alt='#{gravatar_hexdigest(member)}']")
      if links || @user == member
        expect(page).to have_link member.handle
      else
        expect(page).to have_content member.handle
        expect(page).not_to have_link member.handle
      end
    end
  end
end
