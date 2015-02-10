class CreateProjectsDatapaths < ActiveRecord::Migration
  def change
    create_table :projects_datapaths do |t|
      t.integer :project_id
      t.integer :datapath_id
      t.string  :sub_directory, :default => '', :null => false
      t.string  :name

      t.timestamps
    end
  end
end
