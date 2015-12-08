class CreateLoci < ActiveRecord::Migration
  def change
    create_table :loci do |t|
      t.references :user, index: true
      t.integer :locusable_id
      t.string  :locusable_type
      t.string :range

      t.timestamps
    end
  end
end
