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
  expect(page).to have_css('h1', text: 'Users')
end

### When

When /^I visit the users page$/ do
  visit users_path
end

### Then

Then /^I should be on the users page$/ do
  expect(current_path).to eq users_path
end

Then /^I should see a list of users$/ do
  expect(User.count).to be > 0
  User.all do |user|
    expect(page).to have_content user.email
  end
end

Then /^I should be redirected to the sign in page$/ do
  expect(current_path).to eq new_user_session_path
end
