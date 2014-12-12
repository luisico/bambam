class ProjectsDatapath < ActiveRecord::Base
  belongs_to :project
  belongs_to :datapath
  has_many :tracks

  def full_path
    datapath = Datapath.find(self.datapath_id).path
    sub_directory = self.sub_directory
    if sub_directory.empty?
      datapath
    else
      File.join datapath, sub_directory
    end
  end
end
