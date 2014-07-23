class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.integer :owner_id

      t.timestamps
    end

    add_index :projects, :name
  end
end
