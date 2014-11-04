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
