class User < ActiveRecord::Base
  rolify
  has_many :memberships, dependent: :destroy
  has_many :groups, :through => :memberships
  has_many :projects_users, dependent: :destroy
  has_many :projects, :through => :projects_users


  # Authentication
  devise :database_authenticatable, :invitable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :all_except, ->(user) { where.not(id: user) }

  def handle
    first_space_last = "#{self.first_name} #{self.last_name}"
    (first_space_last).blank? ? self.email : first_space_last.strip
  end
end
