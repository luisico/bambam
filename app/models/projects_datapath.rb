class ProjectsDatapath < ActiveRecord::Base
  belongs_to :project, touch: true
  belongs_to :datapath
  has_many :tracks

  validate :datapath_id_exists, :sub_directory_not_nil

  def full_path
    Pathname.new('').join(datapath.path, sub_directory ? sub_directory : "").to_s
  end

  def datapath_id_exists
    errors.add(:datapath_id, "datapath must exist") unless Datapath.exists?(datapath_id)
  end

  def sub_directory_not_nil
    errors.add :sub_directory, 'can not be nil' if sub_directory.nil?
  end
end
