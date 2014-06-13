# Admin and users
admin1 = FactoryGirl.create(:admin)
admin2 = FactoryGirl.create(:admin)
inviter = FactoryGirl.create(:inviter)
users = FactoryGirl.create_list(:user, 3)

# Groups & membership
FactoryGirl.create(:group, owner: admin1, members: [inviter, users[0], users[1]])
FactoryGirl.create(:group, owner: admin2, members: [admin1, users[2]])

# Tracks
tracks = FactoryGirl.create_list(:track, 3)

# Projects & projects_users
FactoryGirl.create(:project, owner: users[0], users: [admin, inviter, users[0], users[1]], tracks: [tracks[0], tracks[2]])
FactoryGirl.create(:project, owner: inviter, users: [inviter, users[2]], tracks: [tracks[1]])
