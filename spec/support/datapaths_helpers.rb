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
      formats = %w(*.bw *.bam /)
      globs = formats.map{ |f| File.join(datapath.path, "**", f) }
      file_system = Dir.glob(globs)

      if subdir
        file_path = file_system.select {|path| Pathname.new(path).basename.to_s == subdir}.join
        path = file_path.gsub(datapath.path + '/', "")[0...-1]
        FactoryGirl.create(:projects_datapath, project: project, datapath: datapath, path: path)
      else
        FactoryGirl.create(:projects_datapath, project: project, datapath: datapath, path: '')
      end
    end

    def fancytree_node(title)
      # TODO make sure these take advantage of capybara inherent waiting
      page.find('span.fancytree-title', text: title, :match => :prefer_exact)
    end

    def fancytree_parent(node_title)
      fancytree_node(node_title).find(:xpath, '../../..')
    end

    def select_node(title)
      @title = title
      fancytree_parent(title).find('span.fancytree-checkbox').click
    end

    def expand_node(title)
      fancytree_parent(title).find('span.fancytree-expander').click
    end
  end
end
