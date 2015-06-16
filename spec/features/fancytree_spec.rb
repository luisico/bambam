require 'rails_helper'

RSpec.feature "fancytree" do
  before do
    @manager = FactoryGirl.create(:manager)
    @project = FactoryGirl.create(:project, owner: @manager)
    @datapaths = create_datapaths

    add_user_to_datapaths(@manager, @datapaths)
    sign_in @manager
  end

  scenario "Manager views selected datapath on project page", js: true do
    preselect_datapath(@project, @datapaths[0], 'subdir1')
    visit project_path(@project)
    expect(page).to have_text 'subdir1'
  end

  scenario "Manager views selected track on project page", js: true do
    projects_datapath = preselect_datapath(@project, @datapaths[0], 'subdir2')
    preselect_track(projects_datapath, 'track4', 'bam', @manager)
    visit project_path(@project)
    expect(page).to have_text 'track4.bam'
  end
end
