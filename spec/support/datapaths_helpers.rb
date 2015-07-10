module Datapaths
  module TestHelpers
    def create_datapaths(dirs=[1, 2, 3])
      dirs.collect do |num|
        FactoryGirl.create(:datapath, path: 'spec/test_tree/datapath' + num.to_s)
      end
    end

    def add_user_to_datapaths(user, datapaths)
      datapaths.each do |datapath|
        datapath.users << user
      end
    end

    def preselect_datapath(project, datapath, subdir=nil)
      if subdir
        formats = %w(*.bw *.bam /)
        globs = formats.map{ |f| File.join(datapath.path, "**", f) }
        file_path = Dir.glob(globs).select {|path| Pathname.new(path).basename.to_s == subdir}.join
        path = file_path.gsub(datapath.path + '/', "")[0...-1]
        FactoryGirl.create(:projects_datapath, project: project, datapath: datapath, path: path)
      else
        FactoryGirl.create(:projects_datapath, project: project, datapath: datapath, path: '')
      end
    end
  end
end
