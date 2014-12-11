class ProjectsDatapath < ActiveRecord::Base
  belongs_to :project
  belongs_to :datapath
end
