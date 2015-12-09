FactoryGirl.define do
  factory :track_locus, class: "Locus" do
    association :locusable, :factory => :track
    locusable_type 'Track'
    user
    range '0'
  end

  factory :project_locus, class: "Locus" do
    association :locusable, :factory => :project
    locusable_type 'Project'
    user
    range '0'
  end
end
