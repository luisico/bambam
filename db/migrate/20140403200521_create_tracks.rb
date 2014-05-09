class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :name, null: false
      t.string :path, null: false

      t.timestamps
    end

    add_index :tracks, :name
  end
end
