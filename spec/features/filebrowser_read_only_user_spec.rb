require 'rails_helper'

RSpec.feature "Read-only user filebrowser functions", js: true do
  before do
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project, users: [@user])
    @project.projects_users.first.update(read_only: true)
    @datapaths = create_datapaths

    add_user_to_datapaths(@project.owner, @datapaths)

    sign_in @user
  end

  scenario "cannot add a track to a datapath" do
    preselect_datapath(@project, @datapaths[0])
    visit project_path(@project)

    expect(fancytree_parent('track11')).not_to have_css '.fancytree-checkbox'
  end

  scenario "cannot remove their own track from a datapath" do
    datapath1 = preselect_datapath(@project, @datapaths[0])
    track11 = preselect_track(datapath1, 'track11', 'bam', @user)
    visit project_path(@project)

    expect(fancytree_parent('track11')).not_to have_css '.fancytree-checkbox'
  end

  scenario "cannot remove another users track from a top level datapath" do
    datapath1 = preselect_datapath(@project, @datapaths[0])
    preselect_track(datapath1, 'track11', 'bam', @project.owner)
    visit project_path(@project)

    expect(fancytree_parent('track11')).not_to have_css '.fancytree-checkbox'
  end

  scenario "cannot sees siblings folders of selected folder" do
    preselect_datapath(@project, @datapaths[0], 'dir11')
    visit project_path(@project)

    expect(page).not_to have_selector ".fancytree-title", text: "dir12"
  end

  scenario "cannot sees siblings files of selected folder" do
    preselect_datapath(@project, @datapaths[0], 'dir11')
    visit project_path(@project)

    expect(page).not_to have_selector ".fancytree-title", text: "track11.bam"
  end
end
