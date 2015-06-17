require 'rails_helper'

RSpec.feature "One datapath per file hierarchy" do
  before do
    @manager = FactoryGirl.create(:manager)
    @project = FactoryGirl.create(:project, owner: @manager)
    @datapaths = create_datapaths

    add_user_to_datapaths(@manager, @datapaths)
    @subdir1 = preselect_datapath(@project, @datapaths[0], 'subdir1')

    sign_in @manager
  end

  scenario "manager selects parent of selected datapath", js: true do
    visit project_path(@project)
    expect(fancytree_parent("subdir1")[:class]).to include 'fancytree-selected'

    expect {
      select_node(@datapaths[0].path)
      loop until page.evaluate_script('jQuery.active').zero?
    }.not_to change(@project.projects_datapaths, :count)

    expect(fancytree_parent("subdir1")[:class]).not_to include 'fancytree-selected'
    expect(fancytree_parent(@datapaths[0].path)[:class]).to include 'fancytree-selected'
  end

  scenario "manager selects parent of selected datapath with tracks", js: true do
    %w[track1 track2].each do |name|
      preselect_track(@subdir1, name, 'bam', @manager)
    end

    @project.tracks.each do |track|
      expect(track.projects_datapath).to eq @subdir1
    end

    visit project_path(@project)
    %w[subdir1 track1.bam track2.bam].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end

    expect {
      select_node(@datapaths[0].path)
      loop until page.evaluate_script('jQuery.active').zero?
      @project.reload
    }.not_to change(@project.projects_datapaths, :count)

    @project.tracks.each do |track|
      expect(track.projects_datapath).not_to eq @subdir1
    end

    expect(fancytree_parent("subdir1")[:class]).not_to include 'fancytree-selected'
    [@datapaths[0].path, "track1.bam", "track2.bam"].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end
  end

  scenario "manager selects parent of two selected datapaths", js: true do
    subdir2 = preselect_datapath(@project, @datapaths[0], 'subdir2')

    visit project_path(@project)
    %w[subdir1 subdir2].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end

    expect {
      select_node(@datapaths[0].path)
      loop until page.evaluate_script('jQuery.active').zero?
      @project.reload
    }.to change(@project.projects_datapaths, :count).by(-1)

    %w[subdir1 subdir2].each do |title|
      expect(fancytree_parent(title)[:class]).not_to include 'fancytree-selected'
    end
    expect(fancytree_parent(@datapaths[0].path)[:class]).to include 'fancytree-selected'
  end

  scenario "manager selects parent of two selected datapaths with tracks", js: true do
    %w[track1 track2].each do |name|
      preselect_track(@subdir1, name, 'bam', @manager)
    end

    subdir2 = preselect_datapath(@project, @datapaths[0], 'subdir2')
    %w[track4 track5].each do |name|
      preselect_track(subdir2, name, 'bam', @manager)
    end

    visit project_path(@project)
    %w[subdir1 track1.bam track2.bam subdir2 track4.bam track5.bam].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end

    expect {
      select_node(@datapaths[0].path)
      loop until page.evaluate_script('jQuery.active').zero?
      @project.reload
    }.to change(@project.projects_datapaths, :count).by(-1)

    @project.tracks.each do |track|
      expect(track.projects_datapath).to eq ProjectsDatapath.last
    end

    %w[subdir1 subdir2].each do |title|
      expect(fancytree_parent(title)[:class]).not_to include 'fancytree-selected'
    end

    [@datapaths[0].path] + %w[track1.bam track2.bam track4.bam track5.bam].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end
  end
end
