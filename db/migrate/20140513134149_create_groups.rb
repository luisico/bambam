class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :owner_id

      t.timestamps
    end

    if User.count > 0
      if admin = User.with_role(:admin).first
        Group.create(name: 'Orphan Group', members: User.all, owner: admin)
      end
    end
  end
end
