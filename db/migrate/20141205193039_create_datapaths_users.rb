class CreateDatapathsUsers < ActiveRecord::Migration
  def change
    create_table :datapaths_users do |t|
      t.integer :user_id
      t.integer :datapath_id

      t.timestamps
    end
  end
end
