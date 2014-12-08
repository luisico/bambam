### Methods

def build_datapath
  @datapath_attrs ||= FactoryGirl.attributes_for(:test_datapath)
  Pathname.new(@datapath_attrs[:path]).mkpath unless File.exist?(@datapath_attrs[:path])
end

def fill_data_path_form(datapath=nil)
  datapath ||= @datapath_attrs
  fill_in 'new datapath', with: datapath[:path]
  yield if block_given?
  click_button 'Create datapath'
  sleep 1
end

### Given

### When

When /^I create a new datapath$/ do
  expect {
    build_datapath
    fill_data_path_form
  }.to change(Datapath, :count).by(1)
end

When /^I create a new datapath with an invalid path$/ do
   expect {
    fill_data_path_form({path:"my/invalid/datapath" })
  }.not_to change(Datapath, :count)
end

When /^I create a new datapath with managers$/ do
  expect {
    build_datapath
    fill_data_path_form do
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
