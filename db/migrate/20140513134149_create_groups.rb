class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :owner_id

      t.timestamps
    end

    if User.count > 0
      Group.create(name: 'Orphan', members: User.all, owner: User.first)
    end
  end
end
