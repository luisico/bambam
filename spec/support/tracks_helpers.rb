module Tracks
  module TestHelpers
    def cp_track(path, type='bam')
      file = 'test_500_sorted.bam'
      file = file + '.bai' if type == 'bai'
      Pathname.new(path).dirname.mkpath
      FileUtils.cp File.join(Rails.root, 'spec', 'data', 'tracks', file), path
    end

    def preselect_track(projects_datapath, name, ext, owner)
      formats = Track::FILE_FORMATS.collect{|key, value| '*.' + value[:extension]}
      globs = formats.map{ |f| File.join(projects_datapath.full_path, "**", f) }
      files = Dir.glob(globs)

      track_path = files.select {|file| Pathname.new(file).basename.to_s == name + '.' + ext}.join
      path = track_path.gsub(projects_datapath.full_path + '/', "")
      FactoryGirl.create(:track, projects_datapath: projects_datapath, path: path, name: name, owner: owner)
    end
  end
end
