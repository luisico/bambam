class Project < ActiveRecord::Base
  has_many :projects_users, dependent: :destroy
  has_many :users, through: :projects_users

  has_many :projects_datapaths, dependent: :destroy
  has_many :datapaths, through: :projects_datapaths
  has_many :tracks,    through: :projects_datapaths, source: :tracks

  belongs_to :owner, class_name: "User", foreign_key: :owner_id

  validates_presence_of :name, :owner_id

  before_validation :add_owner_to_users

  def allowed_paths
    projects_datapaths.collect{ |project_datapath| project_datapath.full_path }
  end

  def regular_users
    users.where(projects_users: { read_only: false })
  end

  def read_only_users
    users.where(projects_users: { read_only: true })
  end

  private

  def add_owner_to_users
    users << owner if owner && !users.include?(owner)
  end
end
