class Track < ActiveRecord::Base
  belongs_to :projects_datapath
  # TODO revisit delegated project= on track when adding tracks to fancytree
  delegate :project, :project=, :project_id, :project_id=, to: :projects_datapath, allow_nil: true
  delegate :datapath, :datapath=, :datapath_id, :datapath_id=, to: :projects_datapath, allow_nil: true

  belongs_to :owner, class_name: "User", foreign_key: :owner_id
  has_many :share_links
  has_many :tracks_users, dependent: :destroy

  validates_presence_of :name, :owner_id, :genome
  #TODO adding presence validation on project_id breaks nested updated.
  validates_path_of :path
  validates :path, format: { with: /\A.*\.(bw|bam)\z/,
    message: "file must have extension .bw or .bam" }

  after_save :update_projects_datapath

  def full_path
    File.join projects_datapath.full_path, path
  end

  protected

  def update_projects_datapath
    self.projects_datapath.save if self.projects_datapath.changed?
  end
end
