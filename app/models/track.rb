class Track < ActiveRecord::Base
  validates_presence_of :name, :path
  validates :path, format: { with: /\A.*\.(bw|bam)\z/,
    message: "file must have extension .bw or .bam" }
  validates_path_of :path, within: ENV['ALLOWED_TRACK_PATHS'].split(':')
end
