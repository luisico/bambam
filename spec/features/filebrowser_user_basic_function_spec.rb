require 'rails_helper'

RSpec.feature "User basic filebrowser functions", js: true do
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
    expand_node('dir11')
    expect(fancytree_parent('dir111')).not_to have_css '.fancytree-checkbox'
  end

  scenario "adds a track to a datapath" do
    preselect_datapath(@project, @datapaths[0])
    visit project_path(@project)

    expect {
      select_node('track11.bam')
    }.to change(@project.tracks, :count).by(1)

    new_track = Track.last
    expect(fancytree_parent('track11')[:class]).to include 'fancytree-selected'
    expect(fancytree_parent('track11')).to have_link  new_track.name
    expect(fancytree_parent('track11')).to have_content  new_track.genome
    expect(fancytree_parent('track11')).to have_css ".service.fi-eye"
    expect(new_track.owner).to eq @user
  end

  scenario "is informed of a failed track addition" do
    preselect_datapath(@project, @datapaths[0])
    visit project_path(@project)

    expect {
      allow_any_instance_of(Track).to receive(:save).and_return(false)
      allow_any_instance_of(Track).to receive_message_chain(:errors, :full_messages).and_return(["my", "error"])
      select_node('track11.bam')
    }.not_to change(@project.tracks, :count)
    expect(fancytree_parent('track11.bam')[:class]).to include 'error-red'
    expect(fancytree_node('track11.bam').text).to include "my; error"
  end

  scenario "is informed when adding track to invalid datapath" do
    datapath1 = preselect_datapath(@project, @datapaths[0])
    visit project_path(@project)

    expect {
      datapath1.destroy
      select_node('track11.bam')
    }.not_to change(@project.tracks, :count)
    expect(fancytree_parent('track11.bam')[:class]).to include 'error-red'
    expect(fancytree_node('track11.bam').text).to include "You don't have permission to create"
  end

  scenario "removes a track from a datapath" do
    datapath1 = preselect_datapath(@project, @datapaths[0])
    track11 = preselect_track(datapath1, 'track11', 'bam', @user)
    visit project_path(@project)

    expect(fancytree_parent('track11')[:class]).to include 'fancytree-selected'
    expect(fancytree_parent('track11')).to have_link  track11.name
    expect(fancytree_parent('track11')).to have_content  track11.genome
    expect(fancytree_parent('track11')).to have_css ".service.fi-eye"

    expect {
      deselect_node('track11.bam')
    }.to change(@project.tracks, :count).by(-1)

    expect(fancytree_parent('track11')[:class]).not_to include 'fancytree-selected'
    expect(fancytree_parent('track11')).not_to have_link  track11.name
    expect(fancytree_parent('track11')).not_to have_content  track11.genome
    expect(fancytree_parent('track11')).not_to have_css ".service.fi-eye"
  end

  scenario "is informed of a failed track deletion" do
    datapath1 = preselect_datapath(@project, @datapaths[0])
    preselect_track(datapath1, 'track11', 'bam', @user)
    allow_any_instance_of(Track).to receive(:destroy).and_return(false)

    expect {
    visit project_path(@project)
      deselect_node('track11.bam')
    }.not_to change(@project.tracks, :count)
    expect(fancytree_parent('track11.bam')[:class]).to include 'error-red'
    expect(fancytree_node('track11.bam').text).to include "Record not deleted"
  end

  scenario "can add and immediately remove a datapath" do
    preselect_datapath(@project, @datapaths[0])
    visit project_path(@project)

    expect {
      select_node('track11.bam')
    }.to change(@project.tracks, :count).by(1)
    expect(fancytree_parent('track11')[:class]).to include 'fancytree-selected'

    expect {
      deselect_node('track11.bam')
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
