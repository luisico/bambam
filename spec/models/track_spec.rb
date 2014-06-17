require 'spec_helper'

describe Track do
  before { @track = FactoryGirl.build(:test_track) }

  subject { @track }

  describe "database fields" do
    it_behaves_like "timestampable table"
    it { should have_db_column(:name).with_options(null: false) }
    it { should have_db_index(:name).unique(false) }
    it { should have_db_column(:path).with_options(null:false) }
    it { should have_db_column(:project_id).with_options(null: false) }
  end

  describe "name" do
    it { should respond_to :name }
    it { should validate_presence_of(:name) }
  end

  describe "path" do
    it { should respond_to :path }

    context 'is validated' do
      after { File.unlink(@track.path) if File.exist?(@track.path) }

      it "should be valid when it exists with a .bam file extension" do
        expect(@track).to be_valid
      end

      it "should be valid when it exists with a .bw file extension" do
        track = FactoryGirl.build(:test_track, path: File.join('tmp', 'mytrack.bw'))
        cp_track track.path, 'bw'
        expect(track).to be_valid
        File.unlink track.path
      end

      context "should not be valid" do
        it "when it does not exist" do
          File.unlink(@track.path)
          expect(@track).not_to be_valid
        end

        it "when it is empty" do
          Pathname.new(@track.path).truncate(0)
          expect(@track).not_to be_valid
        end

        it "when it is not included in allowed paths" do
          track = FactoryGirl.build(:test_track, path: File.join('', 'tmp', 'mytrack.bam'))
          cp_track track.path
          expect(track).not_to be_valid
          File.unlink track.path
        end

        it "when it does not have a valid file extenstion" do
          track = FactoryGirl.build(:test_track, path: File.join('tmp', 'mytrack.ext'))
          cp_track track.path
          expect(track).not_to be_valid
          File.unlink track.path
        end
      end

      context "env var ALLOWED_TRACK_PATHS" do
        it "should be splitted if for paths" do
          pending "Works, but don't know how to change ENV dynamically in rspec"
        end
      end
    end
  end

  describe "project_id" do
    it {should respond_to :project}
    it { should validate_presence_of(:project_id) }
  end
end
