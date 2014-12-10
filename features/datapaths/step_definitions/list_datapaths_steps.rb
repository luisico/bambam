### Methods

### Given

### When

When /^I visit the datapaths page$/ do
  visit datapaths_path
end

### Then

Then /^I should see a list of all datapaths$/ do
  @datapaths.each do |datapath|
    expect(page).to have_content datapath.path
  end
end

Then /^I should( not)? see a message that no datapaths exist$/ do |negate|
  if negate
    within('#datapath-list') {
      expect(page).not_to have_content "no datapaths in the system"
    }
  else
    within('#datapath-list') {
      expect(page).to have_content "no datapaths in the system"
    }
  end
end

Then /^I should be on the datapaths page$/ do
  expect(current_path).to eq datapaths_path
end
