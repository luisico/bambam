class CreateDatapaths < ActiveRecord::Migration
  def change
    create_table :datapaths do |t|
      t.string :path, null: false

      t.timestamps
    end

    ENV['ALLOWED_TRACK_PATHS'].split(':').each do |path|
      Datapath.create(path: path)
    end

    add_index :datapaths, :path, unique: true
  end
end
