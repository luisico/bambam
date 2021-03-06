class ProjectsDatapath < ActiveRecord::Base
  belongs_to :project, touch: true
  belongs_to :datapath
  has_many :tracks

  validate :datapath_id_exists
  validates_exclusion_of :path, {in: [nil]}

  def full_path
    Pathname.new('').join(datapath.path, path || "").to_s
  end

  def datapath_id_exists
    errors.add(:datapath_id, "datapath must exist") unless Datapath.exists?(datapath_id)
  end
end
