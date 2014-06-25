class User < ActiveRecord::Base
  rolify
  has_many :memberships, dependent: :destroy
  has_many :groups, :through => :memberships

  # Authentication
  devise :database_authenticatable, :invitable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
