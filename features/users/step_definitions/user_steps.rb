### Methods

def build_visitor
  @visitor ||= FactoryGirl.attributes_for(:user)
end

def create_user
  build_visitor
  delete_user
  @user = FactoryGirl.create(:user, @visitor)
  @signed_in = false
end

def find_user
  build_visitor
  @user ||= User.where(email: @visitor[:email]).first
end

def delete_user
  find_user
  @user.destroy unless @user.nil?
end

### Given

Given /^I exist as a user$/ do
  expect {
    create_user
  }.to change(User, :count).by(1)
end

Given /^I do not exist as a user$/ do
  delete_user
  expect(@user).to be_nil
end

Given /^I am on the users page$/ do
  visit users_path
  expect(page).to have_content('Current users')
end

Given /^there (is|are) (\d+|a) other users? in the system$/ do |foo, n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)

  expect {
    @users = FactoryGirl.create_list(:user, n)
  }.to change(User, :count).by(n)
  @user = @users.last
end

### When

When /^I visit the users page$/ do
  visit users_path
end

### Then

Then /^I should be on the users page$/ do
  expect(current_path).to eq users_path
end

Then /^I should see the invitee email with invitation pending icon$/ do
  within('p', text: @invitee[:email]) do
    expect(page).to have_css('.invite-icon')
  end
end

Then /^I should see a list of users$/ do
  expect(User.count).to be > 0
  User.all.each do |user|
    expect(page).to have_link user.handle
    if user.has_role? :admin
      within('p', text: user.handle) do
        expect(page).to have_css('.admin-icon')
      end
    elsif user.has_role? :manager
      within('p', text: user.handle) do
        expect(page).to have_css('.manager-icon')
      end
    end
  end
end

Then /^I should see their avatars$/ do
  User.all.each do |user|
    expect(page).to have_xpath("//img[@alt='#{gravatar_hexdigest(user)}']")
  end
end

Then /^my (admin|manager) email should not have outstanding invite icon$/ do |role|
  within('p', text: instance_variable_get("@#{role}").handle) do
    expect(page).not_to have_css('.invite-icon')
  end
end

Then /^I should be redirected to the sign in page$/ do
  expect(current_path).to eq new_user_session_path
end
