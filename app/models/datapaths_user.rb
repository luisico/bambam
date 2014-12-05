class DatapathsUser < ActiveRecord::Base
  belongs_to :datapath
  belongs_to :user
end
