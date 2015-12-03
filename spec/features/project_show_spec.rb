require 'rails_helper'

RSpec.feature "project show page", js: true do
  before do
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project, users: [@user])
    @datapaths = create_datapaths

    add_user_to_datapaths(@project.owner, @datapaths)

    sign_in @user
  end

  scenario "add a track to the project and then view it in igv js" do
    preselect_datapath(@project, @datapaths[0])
    visit project_path(@project)

    expect {
      select_node('track11.bam')
    }.to change(@project.tracks, :count).by(1)
    track = Track.last

    click_link "igv-tab"
    project_track = find("#project-track-#{track.id}")
    expect(project_track.text).to eq track.name
    within(project_track) {
      click_link track.name
    }
    expect(page).to have_selector ".igv-track-label-span-base", text: track.name
  end
end
