class CreateDatapaths < ActiveRecord::Migration
  def change
    create_table :datapaths do |t|
      t.string :path, null: false

      t.timestamps
    end
    add_index :datapaths, :path, unique: true
  end
end
