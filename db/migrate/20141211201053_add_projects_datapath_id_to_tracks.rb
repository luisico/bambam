class AddProjectsDatapathIdToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :projects_datapath_id, :integer, null: false
  end
end
