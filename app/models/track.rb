class Track < ActiveRecord::Base
  validates_presence_of :name, :path
end
