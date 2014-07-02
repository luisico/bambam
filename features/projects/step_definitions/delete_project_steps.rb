### Methods

### Given

### When

### Then

Then /^I should( not)? be able to delete a project$/ do |negate|
  if negate
    expect(page).not_to have_link 'Delete'
  else
    expect{
      click_link 'Delete'
    }.to change(Project, :count).by(-1)
    expect(current_path).to eq projects_path
  end
end
