require 'rails_helper'

RSpec.describe Role do
  before { @role = FactoryGirl.build(:role) }

  subject { @role }

  describe "mixes in from rolify" do
    it_behaves_like "timestampable table"
    it { is_expected.to have_db_column :name }
    it { is_expected.to have_db_column :resource_id }
    it { is_expected.to have_db_column :resource_type }
    it { is_expected.to have_db_index :name }
    it { is_expected.to have_db_index [:name, :resource_type, :resource_id] }

    it { is_expected.to have_and_belong_to_many :users }
    it { is_expected.to belong_to :resource }
  end

  it { is_expected.to be_valid }
end
