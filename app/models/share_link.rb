class ShareLink < ActiveRecord::Base
  belongs_to :track
  validates_presence_of :access_token, :track_id
  validate :expires_at_cannot_be_in_the_past
  before_save :default_values

  def expires_at_cannot_be_in_the_past
    if expires_at.present? && expires_at < DateTime.now
      errors.add(:expires_at, "can't be in the past")
    end
  end

  def default_values
    self.notes = "no notes" if self.notes.blank?
    self.expires_at = Time.now + 2.weeks if self.expires_at.blank?
  end

  def expired?
    self.expires_at < Time.now
  end
end
