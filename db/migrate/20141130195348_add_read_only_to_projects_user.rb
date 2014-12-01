class AddReadOnlyToProjectsUser < ActiveRecord::Migration
  def change
    add_column :projects_users, :read_only, :boolean, default: false
  end
end
