class Project < ActiveRecord::Base
  has_many :projects_users, dependent: :destroy
  has_many :users, :through => :projects_users
  has_many :projects_datapaths, dependent: :destroy
  has_many :datapaths, :through => :projects_datapaths
  has_many :tracks, through: :projects_datapaths, source: :tracks
  belongs_to :owner, class_name: "User", foreign_key: :owner_id
  validates_presence_of :name
  accepts_nested_attributes_for :tracks, allow_destroy: true

  def allowed_paths
    self.projects_datapaths.collect do |project_datapath|
      master_datapath = Datapath.find(project_datapath.datapath_id).path
      if project_datapath.sub_directory.present?
        File.join master_datapath, project_datapath.sub_directory
      else
        master_datapath
      end
    end
  end
end
