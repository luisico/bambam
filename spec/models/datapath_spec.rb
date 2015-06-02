require 'spec_helper'

describe Datapath do
  before { @datapath = FactoryGirl.build(:datapath) }
  after { Pathname.new(TEST_BASE).exist? && Pathname.new(TEST_BASE).rmtree }

  subject { @datapath }

  describe "database fields" do
    it { is_expected.to have_db_column(:path).with_options(null: false) }
    it { is_expected.to have_db_index(:path).unique(true) }
  end

  describe "path" do
    it { is_expected.to respond_to :path }
    it { is_expected.to validate_uniqueness_of(:path) }

    context "is validated" do
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
        datapath = FactoryGirl.build(:datapath, path: File.join('tmp', 'tests', 'mydatapath'))
        datapath.path = File.join(' tmp', 'tests', 'mydatapath ')
        expect(datapath).to be_valid
      end

      context "should not be valid" do
        it "when it does not exist" do
          Pathname.new(@datapath.path).rmdir if Pathname.new(@datapath.path).exist?
          expect(@datapath).not_to be_valid
        end

        it "when it exists as a file" do
          track = FactoryGirl.create(:track)
          @datapath.path = track.path
          expect(@datapath).not_to be_valid
        end
      end
    end
  end

  describe "datapaths_users" do
    it { is_expected.to have_many :datapaths_users }
    it { is_expected.to respond_to :datapaths_users }
    it { is_expected.to respond_to :datapaths_user_ids }
  end

  describe "users" do
    it { is_expected.to have_many(:users).through(:datapaths_users) }
    it { is_expected.to respond_to :users }
    it { is_expected.to respond_to :user_ids }
  end

  describe "projects_datapaths" do
    it { is_expected.to have_many :projects_datapaths }
    it { is_expected.to respond_to :projects_datapaths }
    it { is_expected.to respond_to :projects_datapath_ids }
  end

  describe "projects" do
    it { is_expected.to have_many(:projects).through(:projects_datapaths) }
    it { is_expected.to respond_to :projects }
    it { is_expected.to respond_to :project_ids }
  end

  describe "when datapath destroyed" do
    before do
      @datapath.users << FactoryGirl.create(:manager)
      @datapath.save!
      FactoryGirl.create_list(:track, 3, datapath: @datapath)
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

    it "should destroy associated projects datapaths" do
      expect { @datapath.destroy }.to change(ProjectsDatapath, :count).by(-3)
    end

    context "#destroy_associated_tracks" do
      it "should destroy associated tracks" do
        expect { @datapath.destroy }.to change(Track, :count).by(-3)
      end

      it "should not destroy un-associated tracks" do
        track = FactoryGirl.create(:track)
        @datapath.destroy
        expect(Track.count).to eq 1
        expect(Track.first).to eq track
      end
    end

    it "should not remove the actual directory" do
      @datapath.destroy
      expect(File.directory?(@datapath.path)).to be true
    end
  end
end
