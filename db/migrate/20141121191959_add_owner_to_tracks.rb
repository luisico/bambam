class AddOwnerToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :owner_id, :integer

    if Track.count > 0
      if admin = User.with_role(:admin).first
        Track.reset_column_information
        Track.skip_callback(:save, :after, :update_projects_datapath)
        Track.all.each{ |t| t.update!(owner: admin) }
      end
    end

    change_column :tracks, :owner_id, :integer, null: false
  end

  def self.down
    remove_column :tracks, :owner_id, :integer
  end
end
