require 'spec_helper'

describe Datapath do
  before { @datapath = FactoryGirl.build(:test_datapath) }

  subject { @datapath }

  describe "database fields" do
    it { should have_db_column(:path).with_options(null: false) }
    it { should have_db_index(:path).unique(false) }
  end

  describe "path" do
    it { should respond_to :path }

    context "is validated" do
      after { FileUtils.rmtree(@datapath.path) if File.exist?(@datapath.path) }

      it "should be valid when it exists as an empty directory" do
        expect(@datapath).to be_valid
      end

      it "should be valid when it exists as a directory with a file" do
        filepath = File.join @datapath.path, 'test.txt'
        File.open(filepath, 'w')
        expect(File.exist?(filepath)).to be true
        expect(@datapath).to be_valid
      end

      it "stips leading and trailing whitespace from path" do
        datapath = FactoryGirl.build(:test_datapath, path: File.join('tmp', 'mydatapath'))
        datapath.path = File.join(' tmp', 'mydatapath ')
        expect(datapath).to be_valid
        FileUtils.rmtree datapath.path
      end

      context "should not be valid" do
        it "when it does not exist" do
          FileUtils.rmtree @datapath.path
          expect(@datapath).not_to be_valid
        end
      end
    end
  end

  describe "datapaths_users" do
    it { should have_many :datapaths_users }
    it { should respond_to :datapaths_users }
    it { should respond_to :datapaths_user_ids }
  end

  describe "users" do
    it { should have_many :users }
    it { should respond_to :users }
    it { should respond_to :user_ids }
  end

  describe "when datapath destroyed" do
    before do
      @datapath.users << FactoryGirl.create(:manager)
      @datapath.save!
    end

    it "should destroy the datapath" do
      expect { @datapath.destroy }.to change(Datapath, :count).by(-1)
      expect { Datapath.find(@datapath.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "should destroy associated memberships" do
      expect { @datapath.destroy }.to change(DatapathsUser, :count).by(-1)
    end

    it "should not destroy the user" do
      expect { @datapath.destroy }.not_to change(User, :count)
    end
  end
end
