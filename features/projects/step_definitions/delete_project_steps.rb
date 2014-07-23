### Methods

### Given

### When

### Then

Then /^I should be able to delete the project$/ do
  expect {
    click_link 'Delete'
  }.to change(Project, :count).by(-1)
  expect(current_path).to eq projects_path
end
