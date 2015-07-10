require 'rails_helper'

RSpec.feature "Selected parent manager", js: true do
  before do
    @manager = FactoryGirl.create(:manager)
    @project = FactoryGirl.create(:project, owner: @manager)
    @datapaths = create_datapaths

    add_user_to_datapaths(@manager, @datapaths)

    sign_in @manager
  end

  scenario "creates orphan tracks" do
    projects_datapath = preselect_datapath(@project, @datapaths[0])
    %w[track1111 track1112 track1211 track1212].each do |name|
      preselect_track(projects_datapath, name, 'bam', @manager)
    end

    visit project_path(@project)
    [@datapaths[0].path] + %w[track1111.bam track1112.bam track1211.bam track1212.bam].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end

    expect {
      select_node('dir111')
      loop until page.evaluate_script('jQuery.active').zero?
      @project.reload
    }.to change(@project.projects_datapaths, :count).by(1)
    expect(@project.tracks.count).to eq 4

    expect(fancytree_parent(@datapaths[0].path)[:class]).not_to include 'fancytree-selected'
    %w[dir111 track1111.bam track1112.bam dir121 track1211.bam track1212.bam].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end
  end

  scenario "selects child of selected datapath" do
    preselect_datapath(@project, @datapaths[0], 'dir11')
    visit project_path(@project)
    expect(fancytree_parent('dir11')[:class]).to include 'fancytree-selected'

    expect {
      expand_node('dir11')
      select_node('dir111')
      loop until page.evaluate_script('jQuery.active').zero?
    }.not_to change(@project.projects_datapaths, :count)

    expect(fancytree_parent('dir11')[:class]).not_to include 'fancytree-selected'
    expect(fancytree_parent('dir111')[:class]).to include 'fancytree-selected'
  end

  scenario "selects child of selected datapath with tracks" do
    dir11 = preselect_datapath(@project, @datapaths[0], 'dir11')
    %w[track1111 track1112].each do |name|
      preselect_track(dir11, name, 'bam', @manager)
    end

    @project.tracks.each do |track|
      expect(track.projects_datapath).to eq dir11
    end

    visit project_path(@project)
    %w[dir11 track1111.bam track1112.bam].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end
    expand_node('dir112')
    expect(fancytree_parent("track1121.bam")).to have_css '.fancytree-checkbox'

    expect {
      select_node('dir111')
      loop until page.evaluate_script('jQuery.active').zero?
      @project.reload
    }.not_to change(@project.projects_datapaths, :count)

    @project.tracks.each do |track|
      expect(track.projects_datapath).not_to eq dir11
    end

    expect(fancytree_parent("dir11")[:class]).not_to include 'fancytree-selected'
    %w[dir111 track1111.bam track1112.bam].each do |title|
      expect(fancytree_parent(title)[:class]).to include 'fancytree-selected'
    end
    expect(fancytree_parent("track1121.bam")).not_to have_css '.fancytree-checkbox'
  end

  scenario "informed of failed track update" do
    datapath = preselect_datapath(@project, @datapaths[0])
    preselect_track(datapath, "track111", 'bam', @manager)
    visit project_path(@project)

    expect {
      allow_any_instance_of(Track).to receive(:update).and_return(false)
      select_node('dir11')
      loop until page.evaluate_script('jQuery.active').zero?
      @project.reload
    }.not_to change(@project.projects_datapaths, :count)
    expect(fancytree_parent('track111.bam')[:class]).to include 'error-red'
    expect(fancytree_node('track111.bam').text).to include "Record not updated"
  end

  scenario "selects sibling of track hides checkbox on track" do
    preselect_datapath(@project, @datapaths[0])

    visit project_path(@project)
    expand_node(@datapaths[0].path)
    expand_node('dir11')
    expect(fancytree_parent('track111.bam')).to have_css '.fancytree-checkbox'

    expect {
      select_node('dir111')
      loop until page.evaluate_script('jQuery.active').zero?
      @project.reload
    }.not_to change(@project.projects_datapaths, :count)

    expect(fancytree_parent('track111.bam')).not_to have_css '.fancytree-checkbox'
  end

  scenario "selects child resets checkbox on parent sibling track" do
    preselect_datapath(@project, @datapaths[0])

    visit project_path(@project)
    expect(fancytree_parent('datapath1')[:class]).to include 'fancytree-selected'
    expand_node('datapath1')
    expect(fancytree_parent('track11.bam')).to have_css '.fancytree-checkbox'

    expect {
      expand_node('dir11')
      select_node('dir111')
      loop until page.evaluate_script('jQuery.active').zero?
      @project.reload
    }.not_to change(@project.projects_datapaths, :count)

    expect(fancytree_parent('track11.bam')).not_to have_css '.fancytree-checkbox'
  end
end
