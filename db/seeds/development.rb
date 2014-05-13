# Admin and users
FactoryGirl.create(:admin)
FactoryGirl.create(:inviter)
FactoryGirl.create_list(:user, 3)

# Groups & membership
FactoryGirl.create(:group)
FactoryGirl.create(:membership)

# Tracks
FactoryGirl.create_list(:track, 3)
