class Project < ActiveRecord::Base
  has_many :projects_users, dependent: :destroy
  has_many :users, :through => :projects_users
  has_many :tracks
  belongs_to :owner, class_name: "User", foreign_key: :owner_id
  validates_presence_of :name
  accepts_nested_attributes_for :tracks, allow_destroy: true
end
