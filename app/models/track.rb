class Track < ActiveRecord::Base
  belongs_to :projects_datapath, touch: true
  has_one :project,  through: :projects_datapath
  has_one :datapath, through: :projects_datapath

  belongs_to :owner, class_name: "User", foreign_key: :owner_id
  has_many :share_links

  validates_presence_of :name, :owner_id
  #TODO adding presence validation on project_id breaks nested updated.
  validates_path_of :full_path
  validates :path, format: { with: /\A.*\.(bw|bam)\z/,
    message: "file must have extension .bw or .bam" }

  before_validation :strip_whitespace

  scope :user_tracks, ->(user) { includes(project: :projects_users).where(projects_users: {user_id: user}).references(:projects_users) }

  def full_path
    File.join datapath.path, projects_datapath.sub_directory, path
  end

  def strip_whitespace
    self.path = self.path.strip
  end
end
