class CreateTracksUsers < ActiveRecord::Migration
  def change
    create_table :tracks_users do |t|
      t.references :user, index: true
      t.references :track, index: true
      t.string :locus

      t.timestamps
    end
  end
end
