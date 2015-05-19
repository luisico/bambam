### Methods

### Given

Given /^there (is|are) (\d+|a) tracks? in that project$/ do |foo, n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)

  projects_datapath = @projects_datapath || FactoryGirl.create(:projects_datapath, project: @project)
  expect {
    FactoryGirl.create_list(:track, n, projects_datapath: projects_datapath)
  }.to change(Track, :count).by(n)
  @project.reload
  @track = @project.tracks.last
end

Given /^I own (\d+|a) tracks? in that project$/ do |n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)
  owner = (@user || @manager)

  projects_datapath = @projects_datapath || FactoryGirl.create(:projects_datapath, project: @project)
  expect {
    FactoryGirl.create_list(:track, n, projects_datapath: projects_datapath, owner: owner)
  }.to change(Track, :count).by(n)
  @track = @project.tracks.last
  @project.reload
end

Given /^there (is|are) (\d+|a) project tracks? in that sub\-directory$/ do |foo, n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)

  expect {
    @tracks = FactoryGirl.create_list(:track, n, projects_datapath: @project.projects_datapaths.last, owner: @manager)
  }.to change(Track, :count).by(n)
end

### When

### Then

Then /^I should be able to activate a tooltip on the IGV button(s)?$/ do |plural|
  selector = "//a[contains(@class, 'button') and contains(text(), 'igv')]/span[contains(@class, 'has-tip-icon')]"
  if plural
    tooltips = all(:xpath, selector)
    expect(tooltips.count).not_to eq 0
    all('.has-tip-icon', text: 'igv').each do |tooltip|
      tooltip.trigger(:mouseover)
      expect(page).to have_content "IGV must be open on your computer"
    end
  else
    find(:xpath, selector).hover
    expect(page).to have_content "IGV must be open on your computer"
  end
end
