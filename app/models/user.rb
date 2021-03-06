class User < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships
  has_many :projects_users, dependent: :destroy
  has_many :projects, through: :projects_users
  has_many :owned_projects, foreign_key: :owner_id, class_name: 'Project'
  has_many :tracks, foreign_key: :owner_id
  has_many :datapaths_users, dependent: :destroy
  has_many :datapaths, through: :datapaths_users
  has_many :loci, dependent: :destroy

  # Authentication
  devise :database_authenticatable, :invitable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  rolify

  scope :all_except, ->(user) { where.not(id: user) }

  def handle
    first_space_last = "#{self.first_name} #{self.last_name}".strip
    (first_space_last).blank? ? self.email : first_space_last
  end

  def handle_with_email
    self.handle.eql?(self.email) ? self.email : "#{self.handle} [#{self.email}]"
  end

  # Hack: https://github.com/scambra/devise_invitable/issues/554
  def after_password_reset; end
end
