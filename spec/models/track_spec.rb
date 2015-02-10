require 'spec_helper'

describe Track do
  before { @track = FactoryGirl.build(:track) }

  subject { @track }

  describe "database fields" do
    it_behaves_like "timestampable table"
    it { should have_db_column(:name).with_options(null: false) }
    it { should have_db_index(:name).unique(false) }
    it { should have_db_column(:path).with_options(null:false) }
    it { should have_db_column(:projects_datapath_id).with_options(null:false) }
    it { should have_db_column(:owner_id).with_options(null: false) }
  end

  describe "name" do
    it { should respond_to :name }
    it { should validate_presence_of(:name) }
  end

  describe "path" do
    it { should respond_to :path }

    context 'is validated with full_path' do
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

      it "stips leading and trailing whitespace from path" do
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
          pending "test removed"
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
          pending "Works, but don't know how to change ENV dynamically in rspec"
        end
      end
    end
  end

  describe "projects_datapath_id" do
    it { should belong_to :projects_datapath }
    it { should respond_to :projects_datapath_id }
    it "should touch the projects_datapath" do
      expect {
        @track.save
      }.to change(@track.projects_datapath, :updated_at)
    end
  end

  describe "delegated methods" do
    context "project" do
      # TODO add delegate_method matchers when shoulda-matchers gem is updated
      it { should respond_to :project }
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
      it { should respond_to :project_id }
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
      it {should respond_to :datapath}
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
      it {should respond_to :datapath_id}
      it "should change projects_datapath datapath when track datapath_id is changed" do
        @track.save
        expect {
          @track.datapath_id = FactoryGirl.create(:datapath).id
          @track.save
        }.to change(@track.projects_datapath, :datapath)
      end
    end
  end

  describe "owner_id" do
    it {should belong_to :owner}
    it {should respond_to :owner}
    it { should validate_presence_of(:owner_id) }
  end

  describe "share_links" do
    it { should have_many :share_links }
    it { should respond_to :share_links }
    it { should respond_to :share_link_ids }
  end

  describe "#full_path" do
    it "should return the full path of the track" do
      expect(@track.full_path).to eq File.join(
        @track.datapath.path,
        @track.projects_datapath.sub_directory,
        @track.path
      )
    end

    it "should return the full path of the track with empty sub_directory" do
      @track.projects_datapath.sub_directory = ""
      expect(@track.full_path).to eq File.join(
        @track.datapath.path,
        @track.path
      )
    end
  end

  describe "#update_projects_datapath" do
    it "should save changes to the track projects datapath when the track project is changed" do
      projects_datapath = @track.projects_datapath
      expect {
        @track.update_attributes(project: FactoryGirl.create(:project))
      }.to change(projects_datapath, :project_id)
    end
  end
end
