require 'spec_helper'

describe Track do
  before { @track = FactoryGirl.build(:track) }

  subject { @track }

  describe "database fields" do
    it { should have_db_column(:name).with_options(null: false) }
    it { should have_db_index(:name).unique(false) }
    it { should have_db_column(:path).with_options(null:false) }
  end

  describe "name" do
    it { should respond_to :name }
  end

  describe "path" do
    it { should respond_to :path }
  end
end
