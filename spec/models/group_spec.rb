require 'spec_helper'

describe Group do
  before do
    @group = FactoryGirl.build(:group)
  end

  subject { @group }

  describe "database fields" do
    it_behaves_like "timestampable table"
    it { should have_db_column(:name) }
    it { should have_db_column(:user_id) }
  end

  describe "name" do
    it { should respond_to :name }
    it { should validate_presence_of(:name) }
  end
end
