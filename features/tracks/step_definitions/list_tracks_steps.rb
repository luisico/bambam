### Methods

### Given

Given /^there (is|are) (\d+|a|an) tracks? in the system$/ do |foo, n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)
  
  expect {
    FactoryGirl.create_list(:track, n)
  }.to change(Track, :count).by(n)
  @track = Track.last
end

### When

When /^I am on the tracks page$/ do
  visit tracks_path
end

### Then

Then /^I should see a list of tracks$/ do
  expect(Track.count).to be > 0
  Track.all do |track|
    expect(page).to have_content track.name
    expect(page).to have_content track.path
  end
end

Then /^I should see an IGV merge link$/ do
  expect(page).to have_link "IGV merge"
end

Then /^I should see an IGV new link$/ do
  expect(page).to have_link "IGV merge"
end
