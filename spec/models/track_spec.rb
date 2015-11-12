require 'rails_helper'

RSpec.describe Track do
  before { @track = FactoryGirl.build(:track) }

  subject { @track }

  describe "database fields" do
    it_behaves_like "timestampable table"
    it { is_expected.to have_db_column(:name).with_options(null: false) }
    it { is_expected.to have_db_index(:name).unique(false) }
    it { is_expected.to have_db_column(:path).with_options(null:false) }
    it { is_expected.to have_db_column(:projects_datapath_id).with_options(null:false) }
    it { is_expected.to have_db_column(:owner_id).with_options(null: false) }
  end

  describe "name" do
    it { is_expected.to respond_to :name }
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "path" do
    it { is_expected.to respond_to :path }

    context 'is validated' do
      after { File.unlink(@track.path) if File.exist?(@track.path) }

      it "should be valid when it exists with a .bam file extension" do
        expect(@track).to be_valid
      end

      it "should be valid when it exists with a .bw file extension" do
        track = FactoryGirl.build(:track, path: File.join('tmp', 'mytrack.bw'))
        cp_track track.path, 'bw'
        expect(track).to be_valid
        File.unlink track.path
      end

      it "strips leading and trailing whitespace from path" do
        track = FactoryGirl.build(:track, path: File.join('tmp', 'mytrack.bam'))
        cp_track track.path
        track.path = File.join(' tmp', 'mytrack.bam ')
        expect(track).to be_valid
        File.unlink track.full_path
      end

      context "should not be valid" do
        it "when it does not exist" do
          File.unlink(@track.full_path)
          expect(@track).not_to be_valid
        end

        it "when it is empty" do
          Pathname.new(@track.full_path).truncate(0)
          expect(@track).not_to be_valid
        end

        it "when it is not included in allowed paths" do
          skip "test removed"
        end

        it "when it does not have a valid file extenstion" do
          track = FactoryGirl.build(:track, path: File.join('tmp', 'mytrack.ext'))
          cp_track track.path
          expect(track).not_to be_valid
          File.unlink track.path
        end
      end

      context "env var ALLOWED_TRACK_PATHS" do
        it "should be splitted if for paths" do
          skip "Works, but don't know how to change ENV dynamically in rspec"
        end
      end
    end
  end

  describe "projects_datapath_id" do
    it { is_expected.to belong_to :projects_datapath }
    it { is_expected.to respond_to :projects_datapath_id }
  end

  describe "delegated methods" do
    context "project" do
      # TODO add delegate_method matchers when shoulda-matchers gem is updated
      it { is_expected.to respond_to :project }
      it "should change projects_datapath project when track project is changed" do
        @track.save
        expect {
          @track.project = FactoryGirl.create(:project)
          @track.save
        }.to change(@track.projects_datapath, :project)
      end
    end

    context "project_id" do
      # TODO add delegate_method matchers when shoulda-matchers gem is updated
      it { is_expected.to respond_to :project_id }
      it "should change projects_datapath project when track project_id is changed" do
        @track.save
        expect {
          @track.project_id = FactoryGirl.create(:project).id
          @track.save
        }.to change(@track.projects_datapath, :project)
      end
    end

    context "datapath" do
      # TODO add delegate_method matchers when shoulda-matchers gem is updated
      it {is_expected.to respond_to :datapath}
      it "should change projects_datapath datapath when track datapath is changed" do
        @track.save
        expect {
          @track.datapath = FactoryGirl.create(:datapath)
          @track.save
        }.to change(@track.projects_datapath, :datapath)
      end
    end

    context "datapath_id" do
      # TODO add delegate_method matchers when shoulda-matchers gem is updated
      it {is_expected.to respond_to :datapath_id}
      it "should change projects_datapath datapath when track datapath_id is changed" do
        @track.save
        expect {
          @track.datapath_id = FactoryGirl.create(:datapath).id
          @track.save
        }.to change(@track.projects_datapath, :datapath)
      end
    end
  end

  describe "genome" do
    it { is_expected.to respond_to :genome }
    it { is_expected.to have_db_column(:genome).with_options(null: false) }
    it { is_expected.to validate_presence_of(:genome) }

    it "should default to 'hg19'" do
      track = Track.new
      expect(track.genome).to eq 'hg19'
    end
  end

  describe "owner_id" do
    it {is_expected.to belong_to :owner}
    it {is_expected.to respond_to :owner}
    it { is_expected.to validate_presence_of(:owner_id) }
  end

  describe "share_links" do
    it { is_expected.to have_many :share_links }
    it { is_expected.to respond_to :share_links }
    it { is_expected.to respond_to :share_link_ids }
  end

  describe "tracks_users" do
    it { is_expected.to have_many :tracks_users }
    it { is_expected.to respond_to :tracks_users }
    it { is_expected.to respond_to :tracks_user_ids }
  end

  describe "#full_path" do
    it "should return the full path of the track" do
      expect(@track.full_path).to eq File.join(
        @track.datapath.path,
        @track.projects_datapath.path,
        @track.path
      )
    end

    it "should return the full path of the track with empty path" do
      @track.projects_datapath.path = ""
      expect(@track.full_path).to eq File.join(
        @track.datapath.path,
        @track.path
      )
    end
  end

  describe "#update_projects_datapath" do
    it "should save changes to the track projects datapath when the track project is changed" do
      expect {
        @track.update_attributes(project: FactoryGirl.create(:project))
        @track.reload
      }.to change(@track.projects_datapath, :project_id)
    end
  end

  describe "when track is destroyed" do
    before do
      FactoryGirl.create(:tracks_user, track: @track, user: FactoryGirl.create(:user))
      @track.save!
    end

    it "should destroy the project" do
      expect { @track.destroy }.to change(Track, :count).by(-1)
      expect { Track.find(@track.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "should destroy associated tracks_users" do
      expect { @track.destroy }.to change(TracksUser, :count).by(-1)
    end

    it "should not destroy the user" do
      expect { @track.destroy }.not_to change(User, :count)
    end
  end
end
