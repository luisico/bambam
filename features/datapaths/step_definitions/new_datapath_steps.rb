### Methods

def build_datapath
  @datapath_attrs ||= FactoryGirl.attributes_for(:test_datapath)
  Pathname.new(@datapath_attrs[:path]).mkpath unless File.exist?(@datapath_attrs[:path])
end

def create_datapath(opts={})
  click_link "Create new datapath"
  fill_in 'new datapath', with: @datapath_attrs[:path]
  yield if block_given?
  opts[:cancel] ? click_link('Cancel') : click_button('Create datapath')
  sleep 1
end

### Given

### When

When /^I create a new datapath$/ do
  expect {
    build_datapath
    create_datapath
  }.to change(Datapath, :count).by(1)
end

When /^I create a new datapath with an invalid path$/ do
   expect {
    @datapath_attrs = {path:"my/invalid/datapath" }
    create_datapath
  }.not_to change(Datapath, :count)
end

When /^I create a new datapath with managers$/ do
  expect {
    build_datapath
    create_datapath do
      fill_in_select2("datapath_user_ids", with: @manager.handle)
    end
  }.to change(Datapath, :count).by(1)
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

Then /^I should see the datapaths users$/ do
  within("#datapath-#{Datapath.last.id}"){
    expect(page).to have_content @manager.handle
  }
end

Then /^I should be able to cancel the creation of a datapath$/ do
  expect{
    build_datapath
    create_datapath(cancel: true)
  }.not_to change(Datapath, :count)
  expect(page).not_to have_css('.new_datapath')
end
