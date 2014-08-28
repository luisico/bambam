### Methods

def expiration_date(time)
  if time == "1 week"
    Date.today + 1.week
  elsif time == "1 month"
    Date.today + 1.month
  elsif time == "1 year"
    Date.today + 1.year
  end
end

### Given

Given /^that track has (\d+|a|an) share links?$/ do |n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)
  expect {
    FactoryGirl.create_list(:share_link, n, track: @track)
  }.to change(ShareLink, :count).by(n)
  @share_link = ShareLink.last
end

Given /^that track has (\d+|a|an) expired share links?$/ do |n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)

  expect {
    n.times {
      sl = FactoryGirl.build(:share_link, track: @track, expires_at: DateTime.yesterday)
      sl.save(validate: false)
    }
  }.to change(ShareLink, :count).by(n)
  @expired_share_link = ShareLink.last
end

### When

### Then

Then /^I should be able to create a shareable link$/ do
  expect{
    click_link "Create new track share link"
    expect(page).not_to have_content "Create new track share link"
    within('.new_share_link') {
      fill_in 'share_link[expires_at]', with: Time.now + 3.days
      click_button 'Create Share link'
    }
  }.to change(ShareLink, :count).by(1)
end

Then /^I should be able to create a link that expires in "(.*?)"$/ do |time|
  expiration = expiration_date(time)
  expect{
    click_link "Create new track share link"
    expect(page).not_to have_content "Create new track share link"
    within('.new_share_link') {
      click_link time
      click_button 'Create Share link'
    }
  }.to change(ShareLink, :count).by(1)
  expect(ShareLink.last.expires_at.to_s[0..9]).to eq expiration.to_s
end

Then /^I should be able to create a shareable link without entering date$/ do
  expect{
    click_link "Create new track share link"
    expect(page).not_to have_content "Create new track share link"
    within('.new_share_link') {
      click_button 'Create Share link'
    }
  }.to change(ShareLink, :count).by(1)
end

Then /^I should see an expiration date of "(.*?)"$/ do |arg1|
  within("#share_link_#{ShareLink.last.id}") {
    expect(page).to have_content arg1
  }
end

Then /^I should see "(.*?)" in the notes field$/ do |arg1|
  share_link_line = find("#share_link_#{ShareLink.last.id}")
  within(share_link_line) {
    expect(page).to have_content arg1
  }
end

Then /^I should see a link to "(.*?)" the share link$/ do |arg1|
  share_link_line = find("#share_link_#{ShareLink.last.id}")
  within(share_link_line) {
    expect(page).to have_content arg1
  }
end

Then /^I should be able to cancel the creation a shareable link$/ do
  expect{
    click_link "Create new track share link"
    expect(page).not_to have_content "Create new track share link"
    within('.new_share_link') {
      fill_in 'share_link[expires_at]', with: Time.now + 3.days
      click_link 'Cancel'
    }
  }.not_to change(ShareLink, :count)
  expect(page).not_to have_css('.new_share_link')
end

Then /^I should not be able to create a shareable link with expired date$/ do
  expect{
    click_link "Create new track share link"
    expect(page).not_to have_content "Create new track share link"
    within('.new_share_link') {
      fill_in 'share_link[expires_at]', with: DateTime.yesterday
      click_button 'Create Share link'
    }
  }.not_to change(ShareLink, :count)
  expect(page).to have_content("can't be in the past")
end

Then /^I should be able to view the share link$/ do
  click_link "show_track_link_#{@share_link.id}"
  expect(page).to have_content @share_link.access_token
end

Then /^I should be able to view the UCSC track line$/ do
  click_link "show_ucsc_link_#{@share_link.id}"
  expect(page).to have_content @share_link.access_token
end

Then /^I should be able to delete the share link$/ do
  expect{
    page.evaluate_script('window.confirm = function() { return true; }')
    click_link "delete_share_link_#{@share_link.id}"
    sleep 1
  }.to change(ShareLink, :count).by(-1)
end

Then /^I should be able to renew the share link$/ do
  expect{
    click_link "edit_link_#{@share_link.id}"
    within(".edit_share_link") {
      fill_in 'share_link[expires_at]', with: Time.now + 5.days
      click_button 'Update Share link'
      sleep 1
    }
    @share_link.reload
  }.to change(@share_link, :expires_at)
end

Then /^I should be able to renew the link with date that expires in "(.*?)"$/ do |time|
  expiration = expiration_date(time)
  expect{
    click_link "edit_link_#{@share_link.id}"
    within(".edit_share_link") {
      click_link time
      click_button 'Update Share link'
      sleep 1
    }
    @share_link.reload
  }.to change(@share_link, :expires_at)
  expect(@share_link.expires_at.to_s[0..9]).to eq expiration.to_s
end

Then /^I should be able to cancel the renewal the share link$/ do
  expect{
    click_link "edit_link_#{@share_link.id}"
    within(".edit_share_link") {
      fill_in 'share_link[expires_at]', with: Time.now + 5.days
      click_link 'Cancel'
    }
    @share_link.reload
  }.not_to change(@share_link, :expires_at)
end

Then /^I should not be able to renew the share link with expired date$/ do
  expect{
    click_link "edit_link_#{@share_link.id}"
    within(".edit_share_link") {
      fill_in 'share_link[expires_at]', with: DateTime.yesterday
      click_button 'Update Share link'
      sleep 1
    }
    @share_link.reload
  }.not_to change(@share_link, :expires_at)
  expect(page).to have_content "can't be in the past"
end

Then /^I should be able to show and hide the expired share links$/ do
  find(".show-expired-share-links").click
  within("#share_link_#{ShareLink.last.id}") {
    expect(page).to have_content "expired"
    expect(page).to have_content "renew"
  }
  find(".hide-expired-share-links").click
  expect(page).not_to have_css ".expired"
end

Then /^I should be able to delete the expired share link$/ do
  find(".show-expired-share-links").click
  expect{
    click_link "delete_share_link_#{@expired_share_link.id}"
    page.evaluate_script('window.confirm = function() { return true; }')
    sleep 1
  }.to change(ShareLink, :count).by(-1)
end

Then /^the hide\/show link should not be visable$/ do
  expect(page).not_to have_css ".show-expired-share-links"
  expect(page).not_to have_css ".hide-expired-share-links"
end
