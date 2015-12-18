class Locus < ActiveRecord::Base
  belongs_to :user
  belongs_to :locusable, polymorphic: true
end
