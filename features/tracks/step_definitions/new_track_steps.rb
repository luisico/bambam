### Methods

def build_track_with_path(parent_path, subdir='', track_title)
  cp_track File.join parent_path, subdir, track_title
end

### Given

### When

Given /^there is a track in the first project's datapath$/ do
  @track_title = 'my_track.bam'
  build_track_with_path(@project.projects_datapaths.first.full_path, @track_title)
end

### Then

Then /^I should be able to add a track to the project$/ do
  expect {
    fancytree_parent(@project.projects_datapaths.first.full_path).find('span.fancytree-expander').click
    fancytree_parent(@track_title).find('span.fancytree-checkbox').click
    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.to change(@project.tracks, :count).by(1)
end

Then /^I should be the owner of that track$/ do
  owner = (@user || @manager)
  expect(@project.tracks.first.owner).to eq owner
end

Then /^I should be on the track show page$/ do
  expect(current_path).to eq track_path(Track.last)
end

Then /^the page should have the error can't be blank$/ do
  expect(page).to have_content "can't be blank"
end
