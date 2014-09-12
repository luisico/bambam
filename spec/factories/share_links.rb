FactoryGirl.define do
  factory :share_link do
    access_token "c0d00725e6426eea2d9eb779a0ced02a"
    expires_at "#{Time.now + 3.days}"
    notes { "notes for track" }
    track
  end
end
