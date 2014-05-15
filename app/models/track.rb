class Track < ActiveRecord::Base
  validates_presence_of :name, :path
  validates_path_of :path, within: [File.join('', 'zenodotus', 'abc', 'store', 'projects', 'Ivashkivlab'),
                                    File.join('', 'zenodotus', 'dat01', 'ivashkivlab_store'),
                                    'tmp',
                                    File.join('', 'zenodotus') ]
end
