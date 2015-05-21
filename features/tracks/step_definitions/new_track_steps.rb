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
      expect(page).not_to have_css('.track-name', text: @track.name)
      expect(page).not_to have_css('.show-record')
      expect(page).not_to have_css('.fi-eye')
    }
  else
    within(fancytree_parent(@track_title)) {
      expect(page).to have_css('.track-name', text: Track.last.name)
      expect(page).to have_css('.show-record')
      expect(page).to have_css('.fi-eye')
    }
  end
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
