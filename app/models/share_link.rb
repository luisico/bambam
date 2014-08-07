class ShareLink < ActiveRecord::Base
  belongs_to :track

  def self.build_share_link(track)
    ShareLink.create(
      access_token: SecureRandom.hex,
      track_id:     track.id,
      expires_at:   Time.now + 3.days
    )
  end
end
