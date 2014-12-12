class Track < ActiveRecord::Base
  belongs_to :project, :touch => true
  belongs_to :projects_datapath
  belongs_to :owner, class_name: "User", foreign_key: :owner_id
  has_many :share_links
  validates_presence_of :name, :owner_id
  #TODO adding presence validation on project_id breaks nested updated.
  validate :projects_datapath_id_comes_from_tracks_project
  validates_path_of :path, within: ENV['ALLOWED_TRACK_PATHS'].split(':')
  validates :path, format: { with: /\A.*\.(bw|bam)\z/,
    message: "file must have extension .bw or .bam" }

  scope :user_tracks, ->(user) { includes(project: :projects_users).where(projects_users: {user_id: user}).references(:projects_users) }

  def projects_datapath_id_comes_from_tracks_project
    if projects_datapath_id.present? && (ProjectsDatapath.find(projects_datapath_id).project_id != project_id)
      errors.add(:different_projects, "projects datapath id must belong to track's project")
    end
  end
end
