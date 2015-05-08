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

Given /^there is a track in the last available datapath$/ do
  @track_title = 'my_track.bam'
  build_track_with_path(@datapath.path, @track_title)
end

### Then

Then /^I should( not)? be able to add a track to the project$/ do |negate|
  if negate
    expect {
      fancytree_parent(@datapath.path).find('span.fancytree-expander').click
      fancytree_parent(@track_title).find('span.fancytree-checkbox').click
      loop until page.evaluate_script('jQuery.active').zero?
      @project.reload
    }.not_to change(@project.tracks, :count)
  else
    expect {
      fancytree_parent(@project.projects_datapaths.first.full_path).find('span.fancytree-expander').click
      fancytree_parent(@track_title).find('span.fancytree-checkbox').click
      loop until page.evaluate_script('jQuery.active').zero?
      @project.reload
    }.to change(@project.tracks, :count).by(1)
  end
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

Then /^I should be on the track show page$/ do
  expect(current_path).to eq track_path(Track.last)
end

Then /^the page should have the error can't be blank$/ do
  expect(page).to have_content "can't be blank"
end

Then /^I should be informed of the failed track addition$/ do
  expect(fancytree_parent(@track_title)).to have_content 'must select at least 1 parent'
end
