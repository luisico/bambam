class UpgradeDevise < ActiveRecord::Migration
  def change
    change_column :users, :current_sign_in_ip, 'inet USING CAST("current_sign_in_ip" AS inet)'
    change_column :users, :last_sign_in_ip, 'inet USING CAST("last_sign_in_ip" AS inet)'
  end
end
