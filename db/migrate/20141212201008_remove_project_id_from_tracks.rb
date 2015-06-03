class RemoveProjectIdFromTracks < ActiveRecord::Migration
  def change
    remove_column :tracks, :project_id
  end
end
