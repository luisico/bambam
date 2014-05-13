class User < ActiveRecord::Base
  rolify
  has_many :memberships
  has_many :groups, :through => :memberships

  # Authentication
  devise :database_authenticatable, :invitable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
