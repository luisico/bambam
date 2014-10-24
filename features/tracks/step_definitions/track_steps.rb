Then /^I should be able to activate a tooltip on the IGV button(s)?$/ do |plural|
  if plural
    all('.igv-tip').each do |tooltip|
      tooltip.trigger(:mouseover)
      expect(page).to have_content "IGV must be open on your computer"
    end
  else
    find('.igv-tip').hover
    expect(page).to have_content "IGV must be open on your computer"
  end
end
