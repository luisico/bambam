class User < ActiveRecord::Base
  rolify

  # Authentication
  devise :database_authenticatable, :invitable,
         :recoverable, :rememberable, :trackable, :validatable
end
