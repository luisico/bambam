### Methods

### Given

### When

When /^I create a new datapath$/ do
  expect {
    @datapath_attrs ||= FactoryGirl.attributes_for(:test_datapath)
    Pathname.new(@datapath_attrs[:path]).mkpath unless File.exist?(@datapath_attrs[:path])
    fill_in 'new datapath', with: @datapath_attrs[:path]
    click_button 'Create datapath'
    sleep 1
  }.to change(Datapath, :count).by(1)
end

When /^I create a new datapath with an invalid path$/ do
   expect {
    fill_in 'new datapath', with: "my/invalid/datapath"
    click_button 'Create datapath'
    sleep 1
  }.not_to change(Datapath, :count)
end

### Then

Then /^I should the new datapath in the datapath list$/ do
  datapath_list = find("#datapath-list")
  within(datapath_list) {
    expect(page).to have_content Datapath.last.path
  }
end

Then /^the form should have the error "(.*?)"$/ do |error_message|
  form = find("#new_datapath")
  within(form) {
    expect(page).to have_content error_message
  }
end
