class AddGenomeToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :genome, :string, default: "hg19", null: false
  end
end
