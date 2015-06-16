class ChangeSubDirectoryToPath < ActiveRecord::Migration
  def change
    rename_column :projects_datapaths, :sub_directory, :path
  end
end
