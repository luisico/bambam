### Methods

### Given

### When

When /^I click on the track show link$/ do
  click_link 'Show'
end

When /^I am on the track page$/ do
  visit track_path(@track)
end

### Then

Then /^I should be on the show track page$/ do
  expect(current_path).to eq track_path(@track)
end

Then /^I should see the track's name$/ do
  expect(page).to have_content @track.name
end

Then /^I should see the track's path$/ do
  expect(page).to have_content @track.path
end

Then /^I should see the track's creation date$/ do
  expect(page).to have_content @track.created_at
end

Then /^I should be able to acess the track page from a link$/ do
  click_link 'Show'
  expect(current_path).to eq track_path(@track)
end
