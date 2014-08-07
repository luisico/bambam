### Methods

### Given

### When

### Then

Then /^I should be able to create a shareable link$/ do
  expect {
    click_link "Create track line link"
    sleep 1
  }.to change(ShareLink, :count).by(1)
  expect(page).to have_content ShareLink.last.access_token
end
