### Methods

def delete_datapath(datapath)
  click_link "delete-datapath-#{datapath.id}"
  page.evaluate_script('window.confirm = function() { return true; }')
  expect(page).not_to have_link "delete-datapath-#{datapath.id}"
end

### Given

### When

### Then

Then /^I should be able to delete the datapath$/ do
  expect{
    delete_datapath @datapath
  }.to change(Datapath, :count).by(-1)
end
