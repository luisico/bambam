class ShareLink < ActiveRecord::Base
  belongs_to :track
  validates_presence_of :access_token, :track_id, :expires_at
end
