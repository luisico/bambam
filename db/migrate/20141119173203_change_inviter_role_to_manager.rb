class ChangeInviterRoleToManager < ActiveRecord::Migration
  def self.up
    User.with_role(:inviter).each do |user|
      user.add_role(:manager)
      user.remove_role(:admin)
      user.remove_role(:inviter)
    end
  end

  def self.down
    User.with_role(:manager).each do |user|
      user.add_role(:admin)
      user.add_role(:inviter)
      user.remove_role(:manager)
    end
  end
end
