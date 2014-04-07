shared_examples_for "timestampable table" do
  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
end
