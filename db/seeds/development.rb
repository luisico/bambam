# Admin and users
admin = FactoryGirl.create(:admin)
inviter = FactoryGirl.create(:inviter)
users = FactoryGirl.create_list(:user, 3)

# Groups & membership
FactoryGirl.create(:group, owner: users[0], members: [admin, inviter, users[0], users[1]])
FactoryGirl.create(:group, owner: inviter, members: [inviter, users[2]])

# Tracks
FactoryGirl.create_list(:track, 3)
