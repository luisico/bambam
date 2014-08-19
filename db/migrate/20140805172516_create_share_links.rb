class CreateShareLinks < ActiveRecord::Migration
  def change
    create_table :share_links do |t|
      t.string :access_token
      t.datetime :expires_at
      t.integer :track_id
      t.string :notes

      t.timestamps
    end
  end
end
