### Methods

### Given

### When

When /^I am on the project page$/ do
  visit project_path(@project)
end

### Then

Then /^I should be on the show project page$/ do
  expect(current_path).to eq project_path(@project)
end

Then /^I should see the project's name$/ do
  expect(page).to have_content @project.name
end

Then /^I should see the project's tracks$/ do
  project = @project || Project.last
  project.tracks.each do |track|
    expect(page).to have_link track.name
    expect(page).to have_selector(:xpath, "//a[contains(@href, 'http://localhost:60151/load') and text()='igv']")
  end
end

Then /^I should see the project's users with(out)? profile links$/ do |negate|
  project = @project || Project.last
  project.users.each do |user|
    within("#project-user-#{user.id}") do
      if negate
        expect(page).to have_content user.email
        expect(page).not_to have_link user.email
      else
        expect(page).to have_link user.email
      end
    end
  end
end
