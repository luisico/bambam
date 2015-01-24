class ProjectsDatapath < ActiveRecord::Base
  belongs_to :project, touch: true
  belongs_to :datapath
  has_many :tracks

  before_save :remove_nil

  def full_path
    Pathname.new('').join(datapath.path, sub_directory ? sub_directory : "").to_s
  end

  def remove_nil
    self.sub_directory = "" if self.sub_directory.nil?
  end
end
