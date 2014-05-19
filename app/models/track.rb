class Track < ActiveRecord::Base
  validates_presence_of :name, :path
  validates_path_of :path, within: ENV['ALLOWED_TRACK_PATHS'].split(':')
end
