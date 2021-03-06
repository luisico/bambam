require 'rails_helper'

RSpec.feature "Selected child folders manager", js: true do
  before do
    @manager = FactoryGirl.create(:manager)
    @project = FactoryGirl.create(:project, owner: @manager)
    @datapaths = create_datapaths

    add_user_to_datapaths(@manager, @datapaths)

    sign_in @manager
  end

  scenario "selects parent of selected datapath" do
    preselect_datapath(@project, @datapaths[0], 'dir111')
    visit project_path(@project)
    expect(fancytree_parent('dir111')[:class]).to include 'fancytree-selected'

    expect {
      select_node(@datapaths[0].path)
    }.not_to change(@project.projects_datapaths, :count)

    expect(fancytree_parent('dir111')[:class]).not_to include 'fancytree-selected'
    expect(fancytree_parent(@datapaths[0].path)[:class]).to include 'fancytree-selected'
  end

  scenario "selects parent of selected datapath with tracks" do
    dir111 = preselect_datapath(@project, @datapaths[0], 'dir111')
    %w[track1111 track1112].each do |name|
      preselect_track(dir111, name, 'bam', @manager)
    end

    @project.tracks.each do |track|
      expect(track.projects_datapath).to eq dir111
    end

    visit project_path(@project)
    %w[dir111 track1111.bam track1112.bam].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end

    expect {
      select_node(@datapaths[0].path)
      @project.reload
    }.not_to change(@project.projects_datapaths, :count)

    @project.tracks.each do |track|
      expect(track.projects_datapath).not_to eq dir111
    end

    expect(fancytree_parent("dir111")[:class]).not_to include 'fancytree-selected'
    [@datapaths[0].path, "track1111.bam", "track1112.bam"].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end
  end

  scenario "selects parent of two selected datapaths" do
    preselect_datapath(@project, @datapaths[0], 'dir111')
    preselect_datapath(@project, @datapaths[0], 'dir121')

    visit project_path(@project)
    %w[dir111 dir121].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end

    expect {
      select_node(@datapaths[0].path)
      @project.reload
    }.to change(@project.projects_datapaths, :count).by(-1)

    %w[dir111 dir121].each do |title|
      expect(fancytree_parent(title)[:class]).not_to include 'fancytree-selected'
    end
    expect(fancytree_parent(@datapaths[0].path)[:class]).to include 'fancytree-selected'
  end

  scenario "selects parent of two selected datapaths with tracks" do
    dir111 = preselect_datapath(@project, @datapaths[0], 'dir111')
    %w[track1111 track1112].each do |name|
      preselect_track(dir111, name, 'bam', @manager)
    end

    dir121 = preselect_datapath(@project, @datapaths[0], 'dir121')
    %w[track1211 track1212].each do |name|
      preselect_track(dir121, name, 'bam', @manager)
    end

    visit project_path(@project)
    %w[dir111 track1111.bam track1112.bam dir121 track1211.bam track1212.bam].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end

    expect {
      select_node(@datapaths[0].path)
      @project.reload
    }.to change(@project.projects_datapaths, :count).by(-1)

    @project.tracks.each do |track|
      expect(track.projects_datapath).to eq ProjectsDatapath.last
    end

    %w[dir111 dir121].each do |title|
      expect(fancytree_parent(title)[:class]).not_to include 'fancytree-selected'
    end

    [@datapaths[0].path] + %w[track1111.bam track1112.bam track1211.bam track1212.bam].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end
  end

  scenario "selects parent of folder with sibling track reveals checkbox on track" do
    preselect_datapath(@project, @datapaths[0], 'dir111')

    visit project_path(@project)
    expect(fancytree_parent('track111.bam')).not_to have_css '.fancytree-checkbox'

    expect {
      select_node(@datapaths[0].path)
      @project.reload
    }.not_to change(@project.projects_datapaths, :count)

    expect(fancytree_parent('track111.bam')).to have_css '.fancytree-checkbox'
  end
end
