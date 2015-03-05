class RequireProjectOwner < ActiveRecord::Migration
  def change
    change_column_null :projects, :owner_id, false
  end
end
