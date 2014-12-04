### Methods

### Given

Given /^I am on the datapaths page$/ do
  visit datapaths_path
end

### When

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
