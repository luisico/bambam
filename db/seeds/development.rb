# Admin and users
admin1 = FactoryGirl.create(:admin)
admin2 = FactoryGirl.create(:admin)
manager = FactoryGirl.create(:manager)
users = FactoryGirl.create_list(:user, 3)

# Groups & membership
FactoryGirl.create(:group, owner: admin1, members: [manager, users[0], users[1]])
FactoryGirl.create(:group, owner: admin2, members: [admin1, users[2]])

# Projects & projects_users
project1 = FactoryGirl.create(:project, owner: admin1, users: [admin1, manager, users[0], users[1]])
project2 = FactoryGirl.create(:project, owner: admin2, users: [manager, users[2]])

# Tracks
FactoryGirl.create_list(:track, 3, project: project1)
FactoryGirl.create(:track, project: project2)
