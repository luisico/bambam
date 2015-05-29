# Admin and users
admin1 = FactoryGirl.create(:admin)
manager1 = FactoryGirl.create(:manager)
manager2 = FactoryGirl.create(:manager)
users = FactoryGirl.create_list(:user, 3)
users << FactoryGirl.create(:user, :unnamed)

# Groups & membership
FactoryGirl.create(:group, owner: manager1, members: [manager2, users[0], users[1]])
FactoryGirl.create(:group, owner: manager2, members: [users[2], users[3]])

# Datapaths
datapaths = FactoryGirl.create_list(:seeded_datapath, 3, users: [manager1, manager2])
FactoryGirl.create(:seeded_datapath)

# Projects & projects_users
project1 = FactoryGirl.create(:project, owner: manager1, users: [manager2, users[0], users[1]])
project2 = FactoryGirl.create(:project, owner: manager2, users: [users[2], users[3]])

# Projects datapaths
projects_datapath1 = FactoryGirl.create(:projects_datapath, project: project1, datapath: datapaths[0])
projects_datapath2 = FactoryGirl.create(:projects_datapath, project: project1, datapath: datapaths[0])
projects_datapath3 = FactoryGirl.create(:projects_datapath, project: project1, datapath: datapaths[1])
projects_datapath4 = FactoryGirl.create(:projects_datapath, project: project2, datapath: datapaths[2])

# Tracks
FactoryGirl.create_list(:track, 3, projects_datapath: projects_datapath1, owner: users[0])
FactoryGirl.create_list(:track, 3, projects_datapath: projects_datapath2, owner: users[1])
track = FactoryGirl.create(:track, projects_datapath: projects_datapath3, owner: users[1])
FactoryGirl.create(:track, projects_datapath: projects_datapath3, owner: users[1],
  name: 'track_sibling1.bam', path: File.join(track.path.split(File::SEPARATOR)[0...-2], 'track_sibling1.bam'))
FactoryGirl.create(:track, projects_datapath: projects_datapath3, owner: users[1],
  name: 'track_sibling2.bam', path: File.join(track.path.split(File::SEPARATOR)[0...-1], 'sibling', 'track_sibling2.bam'))
FactoryGirl.create_list(:track, 3, projects_datapath: projects_datapath4, owner: users[2])
