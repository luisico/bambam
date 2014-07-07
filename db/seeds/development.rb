# Admin and users
admin1 = FactoryGirl.create(:admin)
admin2 = FactoryGirl.create(:admin)
inviter = FactoryGirl.create(:inviter)
users = FactoryGirl.create_list(:user, 3)

# Groups & membership
FactoryGirl.create(:group, owner: admin1, members: [inviter, users[0], users[1]])
FactoryGirl.create(:group, owner: admin2, members: [admin1, users[2]])

# Projects & projects_users
project1 = FactoryGirl.create(:project, owner: admin1, users: [admin1, inviter, users[0], users[1]])
project2 = FactoryGirl.create(:project, owner: admin2, users: [inviter, users[2]])

# Tracks
FactoryGirl.create_list(:track, 3, project: project1)
FactoryGirl.create(:track, project: project2)
