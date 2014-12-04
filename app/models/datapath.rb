class Datapath < ActiveRecord::Base
  validates_path_of :path, allow_directory: true, allow_empty: true
end
