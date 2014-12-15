class Datapath < ActiveRecord::Base
  has_many :datapaths_users, dependent: :destroy
  has_many :users, through: :datapaths_users

  has_many :projects_datapaths, dependent: :destroy
  has_many :projects, through: :projects_datapaths

  validates_path_of :path, allow_empty: true, allow_file: false
  validates_uniqueness_of :path
end
