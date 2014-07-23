class AddProjectIdToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :project_id, :integer

    if Track.count > 0
      if admin = User.with_role(:admin).first
        project = Project.create(name: 'Orphan Tracks', owner: admin, users: User.all)
        Track.reset_column_information
        Track.all.each{ |t| t.update!(project: project) }
      end
    end

    change_column :tracks, :project_id, :integer, null: false
  end

  def self.down
    remove_column :tracks, :project_id, :integer
    Project.where(name: 'orphaned_projects').destroy_all
  end
end
