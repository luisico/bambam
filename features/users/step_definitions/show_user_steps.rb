### Methods

def gravatar_hexdigest(user)
  Digest::MD5.hexdigest(user.email.downcase).titleize
end

### Given

Given /^my first and last names are blank$/ do
  expect {
    @user.update_attributes(first_name: "", last_name: "")
    @user.reload
  }.to change(@user, :handle)
end

### When

When /^I am on (my|the)? account profile page$/ do |foo|
  user = @user || @manager
  visit user_path(user)
end

When /^I click on the user handle$/ do
  click_on @user.handle
end

### Then

Then /^I should see my user name$/ do
  expect(page).to have_content @user.handle
end

Then /^I should see my email$/ do
  expect(page).to have_content @user.email
end

Then /^I should see my avatar$/ do
  expect(page).to have_xpath("//img[@alt='#{gravatar_hexdigest(@user)}']")
end

Then /^I should see my projects$/ do
  user = @user || @manager
  (user.projects + user.owned_projects).each do |project|
    within("#project_#{project.id}") do
      expect(page).to have_link project.name
      expect(page).to have_content project.owner.handle
    end
  end
end

Then /^I should see my groups$/ do
  @user.groups.each do |group|
    within("#group_#{group.id}") do
      expect(page).to have_link group.name
      expect(page).to have_content group.owner.handle
    end
  end
end

Then /^I should only see my email once$/ do
  within(find("#handle")) {
    expect(page).to have_content(@user.email, count: 1)
  }
end
