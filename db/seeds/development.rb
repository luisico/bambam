# Admin and users
admin = FactoryGirl.create(:admin)
inviter = FactoryGirl.create(:inviter)
users = FactoryGirl.create_list(:user, 3)

# Groups & membership
FactoryGirl.create(:group, members: [admin, inviter, users[0], users[1]])
FactoryGirl.create(:group, members: [inviter, users[2]])

# Tracks
FactoryGirl.create_list(:track, 3)
