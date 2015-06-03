class AddProjectsDatapathIdToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :projects_datapath_id, :integer

    if Track.count > 0
      Track.reset_column_information
      Track.all.each do |track|
        pd = ProjectsDatapath.all.select {|pd| track.path.include?(pd.full_path)}.first
        track.update!(projects_datapath_id: pd.id, path: track.path.gsub(pd.full_path, ''))
      end
    end

    change_column :tracks, :projects_datapath_id, :integer, null: false
  end

  def self.down
    if Track.count > 0
      Track.reset_column_information
      Track.all.each do |track|
        track.update!(path: track.full_path)
      end
    end
    remove_column :tracks, :projects_datapath_id, :integer
  end
end
