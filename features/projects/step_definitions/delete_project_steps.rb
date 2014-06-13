### Methods

### Given

### When

### Then

Then /^I should be able to delete a project$/ do
  expect{
    click_link 'Delete'
  }.to change(Project, :count).by(-1)
  expect(current_path).to eq projects_path
end
