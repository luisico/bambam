### Methods

def edit_datapath(datapath, opts={})
  click_link "edit-datapath-#{datapath.id}"
  datapath_elements_on_edit(datapath)
  yield if block_given?
  opts[:cancel] ? click_link('Cancel') : click_button('Update')
  datapath_elements_after_edit(datapath)
  @datapath.reload
end

def datapath_elements_on_edit(datapath)
  expect(page).to have_css '.edit_datapath'
  expect(page).not_to have_css "#edit-datapath-#{datapath.id}"
  expect(page).not_to have_css "#datapath-users-#{datapath.id}"
end

def datapath_elements_after_edit(datapath)
  expect(page).not_to have_css '.edit_datapath'
  expect(page).to have_css "#edit-datapath-#{datapath.id}"
  expect(page).to have_css "#datapath-users-#{datapath.id}"
end

### Given

### When

### Then

Then /^I should be able to change users in the datapath$/ do
  deleted = []
  expect {
    edit_datapath(@datapath) do
      remove_from_select2(@datapath_managers.last.handle_with_email)
      deleted << @datapath_managers.last
      @managers.each{ |u| fill_in_select2("datapath_user_ids", with: u.handle)}
    end
  }.to change(@datapath.users, :count).by(2)
  expect(current_path).to eq datapaths_path
  deleted.each {|u| expect(@datapath.users).not_to include(u) }
  @managers.each {|u| expect(@datapath.users).to include(u) }
end

Then /^I should be able to change the datapath path$/ do
  expect {
    build_datapath
    edit_datapath(@datapath) do
      fill_in 'new datapath', with: @datapath_attrs[:path]
    end
  }.to change(@datapath, :path)
  expect(@datapath.path).to eq @datapath_attrs[:path]
end

Then /^I should be able cancel the edit of a datapath$/ do
  expect{
    build_datapath
    edit_datapath(@datapath, cancel: true) do
      fill_in 'new datapath', with: @datapath_attrs[:path]
    end
  }.not_to change(@datapath, :path)
end
