class Group < ActiveRecord::Base
  has_many :memberships
  has_many :users, :through => :memberships
  belongs_to :owner, class_name: "User", foreign_key: :user_id
  validates_presence_of :name
end
