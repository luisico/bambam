class ShareLink < ActiveRecord::Base
  belongs_to :track

  def self.build_share_link(track, expiration_date)
    ShareLink.create(
      access_token: SecureRandom.hex,
      track_id:     track.id,
      expires_at:   Date.strptime(expiration_date, "%m/%d/%Y").strftime("%d/%m/%Y")
    )
  end
end
