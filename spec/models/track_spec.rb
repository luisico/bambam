require 'spec_helper'

describe Track do
  before { @track = FactoryGirl.build(:test_track) }

  subject { @track }

  describe "database fields" do
    it_behaves_like "timestampable table"
    it { should have_db_column(:name).with_options(null: false) }
    it { should have_db_index(:name).unique(false) }
    it { should have_db_column(:path).with_options(null:false) }
  end

  describe "name" do
    it { should respond_to :name }
    it { should validate_presence_of(:name) }
  end

  describe "path" do
    it { should respond_to :path }
    it { should validate_presence_of(:path) }

    context 'is validated' do
      before { @track.path = File.join 'tmp', 'mytrack' }
      after { File.unlink(@track.path) if File.exist?(@track.path) }

      it "should be valid when it exists" do
        File.open(@track.path, 'w'){|f| f.puts 'file content'}
        expect(@track).to be_valid
      end

      context "should not be valid" do
        it "when it does not exist" do
          expect(@track).not_to be_valid
        end

        it "when it is empty" do
          File.open(@track.path, 'w'){|f| f.truncate(0)}
          expect(@track).not_to be_valid
        end

        it "when it is not included in allowed paths" do
          @track.path = File.join '', 'tmp', 'mytrack'
          File.open(@track.path, 'w'){|f| f.puts 'file content'}
          expect(@track).not_to be_valid
        end
      end
    end
  end
end
