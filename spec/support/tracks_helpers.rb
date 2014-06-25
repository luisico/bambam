module Tracks
  module TestHelpers
    def cp_track(path, type='bam')
      file = 'test_500_sorted.bam'
      file = file + '.bai' if type == 'bai'
      Pathname.new(path).dirname.mkpath
      FileUtils.cp File.join(Rails.root, 'spec', 'data', 'tracks', file), path
    end
  end
end
