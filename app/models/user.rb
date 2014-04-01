class User < ActiveRecord::Base
  rolify

  # Authentication
  devise :database_authenticatable, :invitable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
