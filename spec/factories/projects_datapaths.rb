# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :projects_datapath do
    project
    datapath
    sequence(:path) {|n| File.join("dir#{n}", "subdir#{n}") }
    sequence(:name) {|n| "Projectsdatapath#{n}"}

    after(:build) do |projects_datapath|
      full_path = File.join projects_datapath.datapath.path, projects_datapath.path
      unless File.exist?(full_path)
        Pathname.new(full_path).mkpath
      end
      unless projects_datapath.project.owner.datapaths.include? projects_datapath.datapath
        projects_datapath.project.owner.datapaths << projects_datapath.datapath
      end
    end
  end
end
