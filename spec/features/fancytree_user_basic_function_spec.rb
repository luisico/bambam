require 'rails_helper'

RSpec.feature "User basic fancytree functions", js: true do
  before do
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project, users: [@user])
    @datapaths = create_datapaths

    add_user_to_datapaths(@project.owner, @datapaths)

    sign_in @user
  end

  scenario "cannot add a top level datapath" do
    visit project_path(@project)
    expect(page).to have_css(".subhead-note", text: "Contact project owner to add/remove datapaths")
  end

  scenario "cannot add a nested datapath" do
    preselect_datapath(@project, @datapaths[0])
    visit project_path(@project)
    expand_node(@datapaths[0].path)
    expect(fancytree_parent('dir11')).not_to have_css '.fancytree-checkbox'
  end

  scenario "adds a track to a datapath" do
    preselect_datapath(@project, @datapaths[0])
    visit project_path(@project)

    expect {
      expand_node(@datapaths[0].path)
      select_node('track11.bam')
      loop until page.evaluate_script('jQuery.active').zero?
    }.to change(@project.tracks, :count).by(1)

    expect(fancytree_parent('track11')[:class]).to include 'fancytree-selected'
  end

  scenario "removes a track from a datapath" do
    datapath1 = preselect_datapath(@project, @datapaths[0])
    preselect_track(datapath1, 'track11', 'bam', @user)
    visit project_path(@project)

    expect(fancytree_parent('track11')[:class]).to include 'fancytree-selected'

    expect {
      select_node('track11.bam')
      loop until page.evaluate_script('jQuery.active').zero?
    }.to change(@project.tracks, :count).by(-1)

    expect(fancytree_parent('track11')[:class]).not_to include 'fancytree-selected'
  end

  scenario "cannot remove another users track from a top level datapath" do
    datapath1 = preselect_datapath(@project, @datapaths[0])
    preselect_track(datapath1, 'track11', 'bam', @project.owner)
    visit project_path(@project)

    expect(fancytree_parent('track11')).not_to have_css '.fancytree-checkbox'
  end
end
