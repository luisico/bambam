class ShareLink < ActiveRecord::Base
  belongs_to :track
  validates_presence_of :access_token, :track_id, :expires_at
  validate :expires_at_cannot_be_in_the_past
  before_save :default_values

  def expires_at_cannot_be_in_the_past
    if expires_at.present? && expires_at < DateTime.now
      errors.add(:expires_at, "can't be in the past")
    end
  end

  def default_values
    self.notes = "No notes" if self.notes.blank?
  end

  def expired?
    self.expires_at < Time.now
  end
end
