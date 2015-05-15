# To run this script, enter the following into the command line:
# foreman run bundle exec rails runner [path_to_this_file]

# Methods

def run_check_on(migration, failures)
  print migration
  if failures.any?
    print "  ERROR\n"
  else
    print "  OK\n"
  end
end

# Header

puts "Release v0.6 migration verfication"
puts "********************"

# Migrations
run_check_on(
  "20141121191959_add_owner_to_tracks",
  Track.all.reject {|t| t.owner == User.with_role(:admin).first}
)

run_check_on(
  "20141130195348_add_read_only_to_projects_user",
  ProjectsUser.all.reject {|pu| pu.read_only == false}
)

allowed_paths = ENV['ALLOWED_TRACK_PATHS'].split(':')
run_check_on(
  "20141204162234_create_datapaths",
  allowed_paths.reject {|path| Datapath.where(path: path).any?}
)

project_owners = Project.all.collect {|p| p.owner}.uniq
datapaths = Datapath.all
run_check_on(
  "20141205193039_create_datapaths_users",
  project_owners.reject {|p_o| p_o.datapaths & datapaths == datapaths}
)

run_check_on(
  "20141209175905_create_projects_datapaths",
  Project.all.reject do |project|
    project.datapaths & project.owner.datapaths == project.datapaths
  end +
  ProjectsDatapath.all.reject do |pd|
    pd.name == Pathname.new(pd.datapath.path).basename.to_s
  end
)

run_check_on(
  "20141211201053_add_projects_datapath_id_to_tracks",
  Track.all.reject do |track|
    track.full_path == File.join(track.projects_datapath.full_path, track.path)
  end
)
