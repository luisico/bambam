### Methods

### Given

### When

### Then

Then /^I should be able to delete a group$/ do
  expect{
    click_link 'Delete'
  }.to change(Group, :count).by(-1)
  expect(current_path).to eq groups_path
end
