class ProjectsDatapath < ActiveRecord::Base
  belongs_to :project, touch: true
  belongs_to :datapath
  has_many :tracks

  validate :datapath_id_exists

  before_save :remove_nil

  def full_path
    Pathname.new('').join(datapath.path, sub_directory ? sub_directory : "").to_s
  end

  def remove_nil
    self.sub_directory = "" if self.sub_directory.nil?
  end

  def datapath_id_exists
    unless Datapath.exists?(datapath_id)
      errors.add(:datapath_id, "datapath must exist")
      false
    end
  end
end
