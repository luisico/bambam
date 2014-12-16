### Methods

### Given

Given /^there (is|are) (\d+|a) tracks? in that project$/ do |foo, n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)
  @project ||= @projects.last
  FactoryGirl.create_list(:track, n.to_i, :project => @project)
  @track = @project.tracks.last
end

Given /^I own (\d+|a) tracks? in that project$/ do |n|
  n = (n == 'a' || n == 'an' ? 1 : n.to_i)
  owner = (@user || @manager)
  @project ||= @projects.last
  FactoryGirl.create_list(:track, n.to_i, :project => @project, owner: owner)
  @track = @project.tracks.last
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
