class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :owner_id

      t.timestamps
    end

    create_table :memberships do |t|
      t.integer :user_id
      t.integer :group_id

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        if User.count > 0
          if admin = User.with_role(:admin).first
            Group.create(name: 'Orphan Users', members: User.all, owner: admin)
          end
        end
      end
    end
  end
end
