### Methods

### Given

### When

### Then

Then /^I should be able to delete a track$/ do
  expect{
    click_link 'Delete'
  }.to change(Track, :count).by(-1)

  expect(current_path).to eq tracks_path
end
