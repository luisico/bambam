### Methods

def gravatar_hexdigest(user)
  Digest::MD5.hexdigest(user.email.downcase).titleize
end

### Given

### When

When /^I am on my Account Profile page$/ do
  visit user_path(@user)
end

When /^I click on the user email$/ do
  click_on @user.email
end

### Then

Then /^I should be on the account profile page$/ do
  expect(current_path).to eq user_path(@user)
end

Then /^I should see my email$/ do
  expect(page).to have_content @user.email
end

Then /^I should see my avatar$/ do
  expect(page).to have_xpath("//img[@alt='#{gravatar_hexdigest(@user)}']")
end

Then /^I should see my groups$/ do
  @user.groups.each do |group|
    expect(page).to have_content group.name
  end
end

Then /^I should see my projects$/ do
  @user.projects.each do |project|
    expect(page).to have_content project.name
  end
end
