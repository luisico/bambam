class AddProjectsDatapathIdToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :projects_datapath_id, :integer

    if Track.count > 0
      # Need to find the project directly with sql
      projects = Hash[Track.connection.select_all("select tracks.id, tracks.project_id from tracks inner join projects on tracks.project_id = projects.id").rows]

      Track.reset_column_information
      Track.all.each do |track|
        project = projects[track.id.to_s]
        pds = ProjectsDatapath.where(project_id: project.to_i).select {|pd| track.path.include?(pd.full_path)}
        if pds.length > 1
          raise ActiveRecord::MigrationError, "Multiple datapaths for track #{track.id}: #{pds.inspect}"
        else
          pd = pds.first
          oldpath = track.path
          track.update!(projects_datapath_id: pd.id, path: track.path.gsub(pd.full_path, ''))
          say "#{track.id} -- #{pd.id} -- #{project.to_i == pd.project.id} -- #{oldpath == track.full_path}"
        end
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
