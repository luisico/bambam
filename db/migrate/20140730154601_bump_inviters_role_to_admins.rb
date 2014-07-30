class BumpInvitersRoleToAdmins < ActiveRecord::Migration
  def self.up
    User.with_role(:inviter).each do |user|
      user.add_role(:admin)
    end
  end

  def self.down
    User.with_role(:inviter).each do |user|
      user.remove_role(:admin)
    end
  end
end
