class AddProjectIdToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :project_id, :integer

    if Track.all.any?
      project = Project.create(name: 'orphaned_projects')

      Track.reset_column_information

      Track.all.each do |track|
        track.project = project
        track.save!
      end
    end

    change_column :tracks, :project_id, :integer, :null => false
  end

  def self.down
    remove_column :tracks, :project_id, :integer
    Project.where(name: 'orphaned_projects').destroy_all
  end
end
