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

Given /^there is( not)? a users link in the navigation bar$/ do |negate|
  if negate
    expect(page).not_to have_css('li a', text: 'Users')
  else
    expect(page).to have_css('li a', text: 'Users')
  end
end

Given /^there is another user in the system$/ do
  @user = FactoryGirl.create(:user)
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
   expect(page).to have_css('.fi-ticket')
  end
end

Then /^I should see a list of users$/ do
  expect(User.count).to be > 0
  User.all.each do |user|
    expect(page).to have_link user.email
    if user.has_role? :admin
      within('p', text: user.email) do
        expect(page).to have_css('.fi-crown')
      end
    elsif user.has_role? :inviter
      within('p', text: user.email) do
        expect(page).to have_css('.fi-key')
      end
    end
  end
end

Then /^I should see their avatars$/ do
  User.all.each do |user|
    expect(page).to have_xpath("//img[@alt='#{Digest::MD5.hexdigest(user.email.downcase).titleize}']")
  end
end

Then /^my (admin|inviter) email should not have outstanding invite icon$/ do |role|
  within('p', text: instance_variable_get("@#{role}").email) do
    expect(page).not_to have_css('.fi-ticket')
  end
end

Then /^I should be redirected to the sign in page$/ do
  expect(current_path).to eq new_user_session_path
end
