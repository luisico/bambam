class ProjectsDatapath < ActiveRecord::Base
  belongs_to :project, touch: true
  belongs_to :datapath
  has_many :tracks

  def full_path
    Pathname.new('').join(datapath.path, sub_directory).to_s
  end
end
