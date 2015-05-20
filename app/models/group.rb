class Group < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, class_name: 'User', foreign_key: 'user_id', source: :user
  belongs_to :owner, class_name: "User", foreign_key: :owner_id

  validates_presence_of :name
end
