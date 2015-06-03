class Datapath < ActiveRecord::Base
  has_many :datapaths_users, dependent: :destroy
  has_many :users, through: :datapaths_users

  before_destroy :destroy_associated_tracks
  has_many :projects_datapaths, dependent: :destroy
  has_many :projects, through: :projects_datapaths

  validates_path_of :path, allow_empty: true, allow_file: false
  validates_uniqueness_of :path

  protected

  def destroy_associated_tracks
    Track.includes(:projects_datapath).where(projects_datapaths: {datapath_id: id}).destroy_all
  end
end
