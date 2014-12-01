# Admin and users
admin1 = FactoryGirl.create(:admin)
manager1 = FactoryGirl.create(:manager)
manager2 = FactoryGirl.create(:manager)
users = FactoryGirl.create_list(:user, 3)
users << FactoryGirl.create(:user, :unnamed)

# Groups & membership
FactoryGirl.create(:group, owner: manager1, members: [manager2, users[0], users[1]])
FactoryGirl.create(:group, owner: manager2, members: [users[2], users[3]])

# Projects & projects_users
project1 = FactoryGirl.create(:project, owner: manager1, users: [manager2, users[0], users[1]])
project2 = FactoryGirl.create(:project, owner: manager2, users: [users[2], users[3]])

# Tracks
FactoryGirl.create_list(:track, 3, project: project1)
FactoryGirl.create(:track, project: project2)
