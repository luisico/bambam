class DatapathsUser < ActiveRecord::Base
  belongs_to :datapath
  belongs_to :user

  before_destroy :destroy_associated_objects

  protected

  def destroy_associated_objects
    ProjectsDatapath.joins(:project).where(datapath: datapath, projects: {owner_id: user}).each do |pd|
      pd.tracks.destroy_all
      pd.destroy
    end
  end
end
