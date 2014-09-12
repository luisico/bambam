### Methods

def expiration_date(time)
  args = time.split(/\s+/)
  Date.today + args[0].to_i.send(args[1])
end

def create_shareable_link(opts={})
  click_link "Create new share link"
  within('.new_share_link') {
    yield if block_given?
    opts[:cancel] ? click_link('Cancel') : click_button('Create Share link')
  }
  expect(page).not_to have_css('.new_share_link') unless opts[:keep]
end

def renew_shared_link(shared_link, opts={})
  click_link "edit_link_#{shared_link.id}"
  within(".edit_share_link") {
    yield if block_given?
    opts[:cancel] ? click_link('Cancel') : click_button('Update Share link')
  }
  expect(page).not_to have_css(".edit_share_link") unless opts[:keep]
  shared_link.reload
end

def delete_shared_link(shared_link)
  click_link "delete_share_link_#{shared_link.id}"
  page.evaluate_script('window.confirm = function() { return true; }')
  expect(page).not_to have_link "delete_share_link_#{shared_link.id}"
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

Then /^I should( not)? see the text "(.*?)" within the share links section$/ do |negate, text|
  within("#share-links-list") {
    if negate
      expect(page).not_to have_content text
    else
      expect(page).to have_content text
    end
  }
end

Then /^I should be able to create a shareable link$/ do
  expect{
    create_shareable_link
  }.to change(ShareLink, :count).by(1)
end

Then /^I should be able to create a link that expires in "(.*?)"$/ do |time|
  expect{
    create_shareable_link do
      click_link time
    end
  }.to change(ShareLink, :count).by(1)
  expect(ShareLink.last.expires_at.to_date).to eq expiration_date(time)
end

Then /^I should be able to create a shareable link with (\d+) days expiration date$/ do |n|
  expect{
    create_shareable_link do
      fill_in 'share_link[expires_at]', with: Time.now + n.to_i.days
    end
  }.to change(ShareLink, :count).by(1)
end

Then /^I should not be able to create a shareable link with expired date$/ do
  expect{
    create_shareable_link(keep: true) do
      fill_in 'share_link[expires_at]', with: DateTime.yesterday
    end
  }.not_to change(ShareLink, :count)
  expect(page).to have_content("can't be in the past")
end

Then /^I should be able to cancel the creation a shareable link$/ do
  expect{
    create_shareable_link(cancel: true)
  }.not_to change(ShareLink, :count)
  expect(page).not_to have_css('.new_share_link')
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
    delete_shared_link @share_link
  }.to change(ShareLink, :count).by(-1)
end

Then /^I should be able to delete the expired share link$/ do
  find(".show-expired-share-links").click
  expect{
    delete_shared_link @expired_share_link
  }.to change(ShareLink, :count).by(-1)
end

Then /^I should be able to renew the share link$/ do
  expect{
    renew_shared_link @share_link do
      fill_in 'share_link[expires_at]', with: Time.now + 5.days
    end
  }.to change(@share_link, :expires_at)
end

Then /^I should be able to renew two share links at once$/ do
  share_links = ShareLink.all

  share_links.each { |s| click_link "edit_link_#{s.id}" }
  expect(page).to have_css(".edit_share_link", count: 2)

  share_links.each do |share_link|
    note = "new notes for share #{share_link.id}"
    expect {
      within("#edit_share_link_#{share_link.id}") {
        fill_in 'share_link[notes]', with: note
        click_button('Update Share link')
      }
      expect(page).not_to have_css("#edit_share_link_#{share_link.id}")
      share_link.reload
    }.to change(share_link, :notes).to(note)
  end
end

Then /^I should be able to renew the link with date that expires in "(.*?)"$/ do |time|
  expect{
    renew_shared_link @share_link do
      click_link time
    end
  }.to change(@share_link, :expires_at)
  expect(@share_link.expires_at.to_date).to eq expiration_date(time)
end

Then /^I should not be able to renew the share link with expired date$/ do
  expect{
    renew_shared_link @share_link, keep: true do
      fill_in 'share_link[expires_at]', with: DateTime.yesterday
    end
  }.not_to change(@share_link, :expires_at)
  expect(page).to have_content "can't be in the past"
end

Then /^I should be able to cancel the renewal the share link$/ do
  expect{
    renew_shared_link @share_link, cancel: true
  }.not_to change(@share_link, :expires_at)
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

Then /^the hide\/show link should not be visable$/ do
  expect(page).not_to have_css ".show-expired-share-links"
  expect(page).not_to have_css ".hide-expired-share-links"
end
