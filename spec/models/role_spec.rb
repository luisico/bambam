require 'spec_helper'

describe Role do
  before { @role = FactoryGirl.build(:role) }

  subject { @role }

  describe "mixes in from rolify" do
    it { should have_db_column :name }
    it { should have_db_column :resource_id }
    it { should have_db_column :resource_type }
    it { should have_db_index :name }
    it { should have_db_index [:name, :resource_type, :resource_id] }

    it { should have_and_belong_to_many :users }
    it { should belong_to :resource }
  end

  it { should be_valid }
end
