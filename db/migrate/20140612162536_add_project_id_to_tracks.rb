class AddProjectIdToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :project_id, :integer
  end
end
