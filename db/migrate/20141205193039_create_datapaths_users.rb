class CreateDatapathsUsers < ActiveRecord::Migration
  def change
    create_table :datapaths_users do |t|
      t.integer :user_id
      t.integer :datapath_id

      t.timestamps
    end

    project_owners = Project.all.collect {|p| p.owner}.uniq

    project_owners.each do |user|
      Datapath.all.each do |datapath|
        DatapathsUser.create(datapath: datapath, user: user)
      end
    end
  end
end
