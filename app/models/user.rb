class User < ActiveRecord::Base
  rolify
  has_many :memberships, dependent: :destroy
  has_many :groups, :through => :memberships
  has_many :projects_users, dependent: :destroy
  has_many :projects, :through => :projects_users


  # Authentication
  devise :database_authenticatable, :invitable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
