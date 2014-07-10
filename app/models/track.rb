class Track < ActiveRecord::Base
  belongs_to :project, :touch => true
  validates_presence_of :name
  #TODO adding presence validation on project_id breaks nested updated.
  validates :path, format: { with: /\A.*\.(bw|bam)\z/,
    message: "file must have extension .bw or .bam" }
  validates_path_of :path, within: ENV['ALLOWED_TRACK_PATHS'].split(':')
end
