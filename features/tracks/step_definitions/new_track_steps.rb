### Methods

def build_track_with_path(parent_path, subdir='', track_title)
  cp_track File.join parent_path, subdir, track_title
end

### Given

Given /^there is a track in the first project's datapath$/ do
  @track_title = 'my_track.bam'
  build_track_with_path(@project.projects_datapaths.first.full_path, @track_title)
end

Given /^there is a track in the last available datapath$/ do
  @track_title = 'my_track.bam'
  build_track_with_path(@datapath.path, @track_title)
end

### When

When /^I expand the first project's datapath$/ do
  expand_node(@project.projects_datapaths.first.full_path)
  expect(page).to have_css 'span.fancytree-title', text: @track_title
end

When /^I expand the last available datapath$/ do
  expand_node(@datapath.path)
  expect(page).to have_css 'span.fancytree-title', text: @track_title
end

When /^I select the track parent datapath$/ do
  expect {
    select_node(@datapath.path)
    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.to change(@project.projects_datapaths, :count).by(1)

end

When /^I deselect the first project's datapath$/ do
  expect{
    select_node(@project.projects_datapaths.first.full_path)
    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.to change(@project.projects_datapaths, :count).by(-1)
end

When /^I click on a track that fails to save$/ do
  allow_any_instance_of(Track).to receive(:save).and_return(false)
  expect {
    select_node(@track_title)
    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.not_to change(@project.tracks, :count)
end

When /^I click on a track with an invalid datapath$/ do
  @project.projects_datapaths.first.datapath.destroy
  expect {
    select_node(@track_title)
    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.not_to change(@project.tracks, :count)
end

### Then

Then /^I should be able to add a track to the project$/ do
  expect {
    select_node(@track_title)
    loop until page.evaluate_script('jQuery.active').zero?
    @project.reload
  }.to change(@project.tracks, :count).by(1)
end

Then /^I should( not)? see the track name and link$/ do |negate|
  if negate
    within(fancytree_parent(@track_title)) {
      expect(page).not_to have_link(@track.name)
      expect(page).not_to have_css('.fi-eye')
    }
  else
    within(fancytree_parent(@track_title)) {
      expect(page).to have_link(Track.last.name)
      expect(page).to have_css('.fi-eye')
    }
  end
end

Then /^I should be the owner of that track$/ do
  owner = (@user || @manager)
  expect(@project.tracks.first.owner).to eq owner
end

Then /^I should( not)? see a checkbox next to the track$/ do |negate|
  if negate
    within(fancytree_parent(@track_title)) {
      expect(page).not_to have_css('span.fancytree-checkbox')
    }
  else
    within(fancytree_parent(@track_title)) {
      expect(page).to have_css('span.fancytree-checkbox')
    }
  end
end

Then /^I should see error "(.*?)"$/ do |error|
  expect(page).to have_content error
end
