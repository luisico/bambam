RSpec.shared_examples_for "timestampable table" do
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
end
