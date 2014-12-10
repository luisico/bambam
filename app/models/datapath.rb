class Datapath < ActiveRecord::Base
  has_many :datapaths_users, dependent: :destroy
  has_many :users, :through => :datapaths_users
  validates_path_of :path, allow_empty: true, allow_file: false
  validates_uniqueness_of :path
end
