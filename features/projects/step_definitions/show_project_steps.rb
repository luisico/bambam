### Methods

### Given

Given /^there is a read only user in that project$/ do
  @projects_user = @project.projects_users.first
  @projects_user.update_attributes(read_only: true)
  expect(@projects_user.read_only).to eq true
end

Given /^I had previously set a project locus$/ do
  expect {
    @locus = FactoryGirl.create(:project_locus, locusable_id: @project.id, user: @user, range: "chr1:1-185,503,660")
  }.to change(Locus, :count).by(1)
end

### When

When /^I am on the project page$/ do
  visit project_path(@project)
end

When /^I am on the Users tab$/ do
  click_link "users-tab"
  expect(page).to have_selector "#project-users"
end

When /^I am on the IGV tab$/ do
  click_link "igv-tab"
  expect(page).to have_selector ".igv-js-link"
end

### Then

Then /^I should be on the project page$/ do
  expect(current_path).to eq project_path(@project)
end

Then /^I should see the project's name$/ do
  expect(page).to have_content @project.name
end

Then /^I should see a project track count of "(.*?)"$/ do |count|
  within(find(".track-count")) {
    expect(page).to have_content count
  }
end

Then /^I should see tabs labled Files, Users and IGV$/ do
  expect(page).to have_selector "#files-tab", text: "Files"
  expect(page).to have_selector "#users-tab", text: "Users"
  expect(page).to have_selector "#igv-tab", text: "IGV"
end

Then /^I should see a section titled "(.*?)"$/ do |title|
  within(find('.project-datapaths')) {
    expect(page).to have_content title
  }
end

Then /^I should see a note about contacting "(.*?)"$/ do |contact|
  within(find(".subhead-note")){
    if contact == "admin"
      expect(page).to have_link "administrator"
    elsif contact == "owner"
      expect(page).to have_link "project owner"
    end
  }
end

Then /^I should see the project's tracks$/ do
  project = @project || Project.last
  project.tracks.each do |track|
    within(find('.project-datapaths')){
      expect(page).to have_link track.name
      expect(page).to have_content track.genome
      expect(page).to have_selector(:xpath, "//a[contains(@href, 'http://localhost:60151/load') and text()='igv']")
    }
  end
end

Then /^I should see the project's users with(out)? profile links$/ do |negate|
  @project ||= Project.last
  if negate
    @project.users.each do |user|
      within("#user-#{user.id}") do
        if user != @user
          expect(page).to have_content user.handle
          expect(page).not_to have_link user.handle
        else
          expect(page).to have_link user.handle
        end
      end
    end
  else
    @project.users.each do |user|
      within("#user-#{user.id}") do
        expect(page).to have_link user.handle
      end
    end
  end
end

Then /^I should see the project's owner$/ do
  project = @project || Project.last
  within("#project-name") do
    expect(page).to have_content @project.owner.handle
  end
end

Then /^I should be on the tracks page$/ do
  expect(current_path).to eq tracks_path
end

Then /^I should be able to designate a user read only$/ do
  @projects_user = @project.projects_users.first
  expect {
    within("#edit_projects_user_#{@projects_user.id}") {
      find('label', text: "set read-only").click
    }
    expect(page).to have_content "restore access"
    @projects_user.reload
  }.to change(@projects_user, :read_only)
end

Then /^that user should move to the read\-only list$/ do
  user = User.find(@projects_user.user_id)
  within("#project-users-regular") {
    expect(page).not_to have_content user.handle
  }
  within("#project-users-read-only") {
    expect(page).to have_content user.handle
    expect(page).to have_css('label', text: 'restore access')
  }
end

Then /^I should be able to remove a user from the read only list$/ do
  expect {
    within("#edit_projects_user_#{@projects_user.id}") {
      find('label', text: "restore access").click
    }
    expect(page).not_to have_content "restore access"
    @projects_user.reload
  }.to change(@projects_user, :read_only)
end

Then /^that user should move to the regular user list$/ do
  user = User.find(@projects_user.user_id)
  within("#project-users-regular") {
    expect(page).to have_content user.handle
    expect(page).not_to have_css('label', text: 'restore access')
  }
  within("#project-users-read-only") {
    expect(page).not_to have_content user.handle
  }
end

Then /^the regular user counts should be (\d+)$/ do |n|
  expect(find("#regular-users").text).to include n
end

Then /^the read only user count should be (\d+)$/ do |n|
  expect(find("#read-only-users").text).to include n
end

Then /^I should be able to activate the igv js viewer$/ do
  click_link 'hg19'
  sleep 1
  expect(page).to have_selector ".igv-root-div"
end

Then /^I should be able to load a track into the viewer$/ do
  click_link @track.name
  expect(page).to have_selector '.igv-track-label-span-base', text: @track.name
end
