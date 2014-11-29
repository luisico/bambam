class Track < ActiveRecord::Base
  belongs_to :project, :touch => true
  belongs_to :owner, class_name: "User", foreign_key: :owner_id
  has_many :share_links
  validates_presence_of :name, :owner_id
  #TODO adding presence validation on project_id breaks nested updated.
  validates_path_of :path, within: ENV['ALLOWED_TRACK_PATHS'].split(':')
  validates :path, format: { with: /\A.*\.(bw|bam)\z/,
    message: "file must have extension .bw or .bam" }

  scope :user_tracks, ->(user) { includes(project: :projects_users).where(projects_users: {user_id: user}).references(:projects_users) }
end
