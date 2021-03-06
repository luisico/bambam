require 'rails_helper'

RSpec.feature "Manager basic filebrowser functions", js: true do
  before do
    @manager = FactoryGirl.create(:manager)
    @project = FactoryGirl.create(:project, owner: @manager)
    @datapaths = create_datapaths

    add_user_to_datapaths(@manager, @datapaths)

    sign_in @manager
  end

  scenario "adds a top level datapath" do
    visit project_path(@project)
    expand_node(@datapaths[0].path)
    expect(fancytree_parent('track11.bam')).not_to have_css '.fancytree-checkbox'

    expect {
      select_node(@datapaths[0].path)
    }.to change(@project.projects_datapaths, :count).by(1)

    expect(fancytree_parent(@datapaths[0].path)[:class]).to include 'fancytree-selected'
    expect(fancytree_parent('track11.bam')).to have_css '.fancytree-checkbox'
  end

  scenario "is informed of a failed datapath addition" do
    allow_any_instance_of(ProjectsDatapath).to receive(:valid?).and_return(false)

    expect {
      visit project_path(@project)
      select_node(@datapaths[0].path)
    }.not_to change(@project.projects_datapaths, :count)
    expect(fancytree_parent(@datapaths[0].path)[:class]).to include 'error-red'
    expect(fancytree_node(@datapaths[0].path).text).to include "Record not created"
  end

  scenario "removes a top level datapath" do
    preselect_datapath(@project, @datapaths[0])
    visit project_path(@project)

    expect(fancytree_parent(@datapaths[0].path)[:class]).to include 'fancytree-selected'
    expect(fancytree_parent('track11.bam')).to have_css '.fancytree-checkbox'

    expect {
      deselect_node(@datapaths[0].path)
    }.to change(@project.projects_datapaths, :count).by(-1)

    expect(fancytree_parent(@datapaths[0].path)[:class]).not_to include 'fancytree-selected'
    expect(fancytree_parent('track11.bam')).not_to have_css '.fancytree-checkbox'
  end

  scenario "is informed of a failed datapath deletion" do
    preselect_datapath(@project, @datapaths[0])
    allow_any_instance_of(ProjectsDatapath).to receive(:destroy).and_return(false)

    expect {
      visit project_path(@project)
      deselect_node(@datapaths[0].path)
    }.not_to change(@project.projects_datapaths, :count)
    expect(fancytree_parent(@datapaths[0].path)[:class]).to include 'error-red'
    expect(fancytree_node(@datapaths[0].path).text).to include "Record not deleted"
  end

  scenario "can add and immediately remove a datapath" do
    visit project_path(@project)
    expect {
      select_node(@datapaths[0].path)
    }.to change(@project.projects_datapaths, :count).by(1)
    expect(fancytree_parent(@datapaths[0].path)[:class]).to include 'fancytree-selected'

    expect {
      deselect_node(@datapaths[0].path)
    }.to change(@project.projects_datapaths, :count).by(-1)
    expect(fancytree_parent(@datapaths[0].path)[:class]).not_to include 'fancytree-selected'
  end

  scenario "adds a nested datapath" do
    visit project_path(@project)

    expect {
      expand_node(@datapaths[0].path)
      select_node('dir11')
    }.to change(@project.projects_datapaths, :count).by(1)

    expect(fancytree_parent('dir11')[:class]).to include 'fancytree-selected'
  end

  scenario "removes a nested datapath" do
    preselect_datapath(@project, @datapaths[0], 'dir11')
    visit project_path(@project)

    expect(fancytree_parent('dir11')[:class]).to include 'fancytree-selected'
    expect(fancytree_parent('track111.bam')).to have_css '.fancytree-checkbox'

    expect {
      deselect_node('dir11')
    }.to change(@project.projects_datapaths, :count).by(-1)

    expect(fancytree_parent('dir11')[:class]).not_to include 'fancytree-selected'
    expect(fancytree_parent('track111.bam')).not_to have_css '.fancytree-checkbox'
  end

  scenario "adds a track to a top level datapath" do
    visit project_path(@project)
    select_node(@datapaths[0].path)

    expect {
      expand_node(@datapaths[0].path)
      select_node('track11.bam')
    }.to change(@project.tracks, :count).by(1)

    expect(fancytree_parent('track11')[:class]).to include 'fancytree-selected'
  end

  scenario "removes a track from a top level datapath" do
    datapath1 = preselect_datapath(@project, @datapaths[0])
    preselect_track(datapath1, 'track11', 'bam', @manager)
    visit project_path(@project)

    expect(fancytree_parent('track11')[:class]).to include 'fancytree-selected'

    expect {
      deselect_node('track11.bam')
    }.to change(@project.tracks, :count).by(-1)

    expect(fancytree_parent('track11')[:class]).not_to include 'fancytree-selected'
  end

  scenario "adds a track to a nested datapath" do
    visit project_path(@project)
    expand_node(@datapaths[0].path)
    select_node('dir11')

    expect {
      expand_node('dir11')
      select_node('track111.bam')
    }.to change(@project.tracks, :count).by(1)

    expect(fancytree_parent('track111')[:class]).to include 'fancytree-selected'
  end

  scenario "removes a track from a nested datapath" do
    dir11 = preselect_datapath(@project, @datapaths[0], 'dir11')
    preselect_track(dir11, 'track111', 'bam', @manager)
    visit project_path(@project)

    expect(fancytree_parent('track111')[:class]).to include 'fancytree-selected'

    expect {
      deselect_node('track111.bam')
    }.to change(@project.tracks, :count).by(-1)

    expect(fancytree_parent('track111')[:class]).not_to include 'fancytree-selected'
  end

  scenario "removes a missing track from a nested datapath" do
    dir11 = preselect_datapath(@project, @datapaths[0], 'dir11')
    preselect_track(dir11, 'track111', 'bam', @manager)
    allow(File).to receive(:exist?).and_return(true, false)
    visit project_path(@project)

    expect(page).to have_selector 'span.fancytree-title', text: 'track111'
    expect(fancytree_parent('track111')[:class]).to include 'fancytree-selected'

    expect {
      deselect_node('track111.bam')
    }.to change(@project.tracks, :count).by(-1)

    expect(page).not_to have_selector 'span.fancytree-title', text: 'track111'
  end
end
