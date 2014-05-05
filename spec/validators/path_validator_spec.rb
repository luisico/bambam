require 'spec_helper'

def empty_directory_path
  subject.path = @path = 'tmp/tracks'
  Dir.mkdir @path
end

def file_path_with_file
  empty_directory_path
  subject.path = 'tmp/tracks/mytrack'
  File.open("#{@path}/mytrack", 'w') { |f| f.puts "file contents" }
end

def directory_path_with_file
  empty_directory_path
  File.open("#{@path}/mytrack", 'w') { |f| f.puts "file contents" }
end

describe ActiveModel::Validations::PathValidator do
  subject { Validatable.new }

  after do
    if File.file?(@path)
      File.unlink(@path)
    elsif File.directory?(@path)
      FileUtils.rm_rf(@path)
    end
  end

  describe "validates path exists in filesystem" do

    before(:all) do
      class Validatable
        include ActiveModel::Validations
        attr_accessor :path
        validates_path_of :path
      end
    end

    after(:all) { Object.send(:remove_const, :Validatable) }

    context "as a path to a file" do
      it "should be valid as an existing file" do
        file_path_with_file
        expect(subject).to be_valid
      end
    end

    context "as a path to a directory" do
      it "should be valid as an existing directory containing a file" do
        directory_path_with_file
        expect(subject).to be_valid
      end
    end

    context "without an existing path or file" do
      before { subject.path = @path = 'non_existing_path' }

      it { should_not be_valid }

      it "should add :exist translation to errors" do
        expect{
          subject.valid?
        }.to change(subject.errors, :size).by(1)
        expect(subject.errors[:path]).to include I18n.t('errors.messages.exist')
      end
    end
  end

  describe "optionally validates path is not empty" do
    context "with option :allow_empty true" do
      before(:all) do
        class Validatable
          include ActiveModel::Validations
          attr_accessor :path
          validates_path_of :path, allow_empty: true
        end
      end
      after(:all) { Object.send(:remove_const, :Validatable) }

      context "as a path to a file" do
        before { file_path_with_file }

        it { should be_valid }

        it "should be valid as an empty file" do
          File.truncate("#{@path}/mytrack", 0)
          expect(subject).to be_valid
        end
      end

      context "as a path to a directory" do
        it "should be valid as an empty directory" do
          empty_directory_path
          expect(subject).to be_valid
        end

        it "should be valid as a non-empty directory" do
          directory_path_with_file
          expect(subject).to be_valid
        end
      end
    end

    context "with option :allow_empty false" do
      before(:all) do
        class Validatable
          include ActiveModel::Validations
          attr_accessor :path
          validates_path_of :path, allow_empty: false
        end
      end
      after(:all) { Object.send(:remove_const, :Validatable) }

      context "as a path to a file" do
        before { file_path_with_file }

        it { should be_valid }

        context "as a path to an empty file" do
          before { File.truncate("#{@path}/mytrack", 0) }

          it { should_not be_valid }

          it "should add :empty translation to errors" do
            expect{
              subject.valid?
            }.to change(subject.errors, :size).by(1)
            expect(subject.errors[:path]).to include I18n.t('errors.messages.empty')
          end
        end
      end

      context "as a path to a directory" do
        context "as an empty directory" do
          before { empty_directory_path }

          it { should_not be_valid }

          it "should add :empty translation to errors" do
            expect{
              subject.valid?
            }.to change(subject.errors, :size).by(1)
            expect(subject.errors[:path]).to include I18n.t('errors.messages.empty')
          end
        end

        context "as a non-empty path" do
          before { directory_path_with_file }

          it { should be_valid }
        end
      end
    end

    context "option :allow_empty defaults to false" do
      before(:all) do
        class Validatable
          include ActiveModel::Validations
          attr_accessor :path
          validates_path_of :path
        end
      end
      after(:all) { Object.send(:remove_const, :Validatable) }

      context "as a path to a an empty file" do
        before do
          file_path_with_file
          File.truncate("#{@path}/mytrack", 0)
        end

        it { should_not be_valid }

        it "should add :empty translation to errors" do
          expect{
            subject.valid?
          }.to change(subject.errors, :size).by(1)
          expect(subject.errors[:path]).to include I18n.t('errors.messages.empty')
        end
      end

      context "as a path to an empty directory" do
        before { empty_directory_path }

        it { should_not be_valid }

        it "should add :empty translation to errors" do
          expect{
            subject.valid?
          }.to change(subject.errors, :size).by(1)
          expect(subject.errors[:path]).to include I18n.t('errors.messages.empty')
        end
      end
    end
  end

  describe "optionally validates path is not a directory" do
    context "with option :allow_directory true" do
      before(:all) do
        class Validatable
          include ActiveModel::Validations
          attr_accessor :path
          validates_path_of :path, allow_directory: true
        end
      end
      after(:all) { Object.send(:remove_const, :Validatable) }

      context "as a path to a file" do
        before { file_path_with_file }

        it { should be_valid }

        context "as an empty file" do
          before { File.truncate("#{@path}/mytrack", 0) }

          it { should_not be_valid }

          it "should add :empty translation to errors" do
            expect{
              subject.valid?
            }.to change(subject.errors, :size).by(1)
            expect(subject.errors[:path]).to include I18n.t('errors.messages.empty')
          end
        end
      end

      context "as a path to directory" do
        it "should be valid as a directory containing a file" do
          directory_path_with_file
          expect(subject).to be_valid
        end

        context "should not be valid as an empty directory" do
          before { empty_directory_path }

          it { should_not be_valid }

          it "should add :empty translation to errors" do
            expect{
              subject.valid?
            }.to change(subject.errors, :size).by(1)
            expect(subject.errors[:path]).to include I18n.t('errors.messages.empty')
          end
        end
      end
    end

    context "with option :allow_directory true and :allow_empty true" do
      before(:all) do
        class Validatable
          include ActiveModel::Validations
          attr_accessor :path
          validates_path_of :path, allow_directory: true, allow_empty: true
        end
      end
      after(:all) { Object.send(:remove_const, :Validatable) }

      context "as a path to a file" do
        it "should be valid as a non-empty file" do
          file_path_with_file
          expect(subject).to be_valid
        end

        it "should be valid as an empty file" do
          file_path_with_file
          File.truncate("#{@path}/mytrack", 0)
          expect(subject).to be_valid
        end
      end

      context "as a path to a directory" do
        it "should be valid as an empty directory" do
          empty_directory_path
          expect(subject).to be_valid
        end

        it "should be valid as a directory with a file" do
          directory_path_with_file
          expect(subject).to be_valid
        end
      end
    end

    context "with option :allow_directory false" do
      before(:all) do
        class Validatable
          include ActiveModel::Validations
          attr_accessor :path
          validates_path_of :path, allow_directory: false
        end
      end
      after(:all) { Object.send(:remove_const, :Validatable) }

      context "as a path to a file" do
        it "should be valid as a file" do
          file_path_with_file
          expect(subject).to be_valid
        end
      end

      context "as a path to a directory" do
        context "as an empty directory" do
          before { empty_directory_path }

          it { should_not be_valid }

          it "should add :directory translation to errors" do
            expect{
              subject.valid?
            }.to change(subject.errors, :size).by(1)
            expect(subject.errors[:path]).to include I18n.t('errors.messages.directory')
          end
        end
      end
    end

    #TODO :allow_directory false & :allow_empty true
  end

  describe "optionally ensure that directory is pre-approved" do
    before(:all) do
      class Validatable
        include ActiveModel::Validations
        attr_accessor :path
        validates_path_of :path, within: %w{ tmp/tracks }
      end
    end
    after(:all) { Object.send(:remove_const, :Validatable) }

    context "as a path to a directory" do
      context "as an approved directory" do
        it "should be valid" do
          directory_path_with_file
          expect(subject).to be_valid
        end

        it "should be valid given a child directory of an approved parent" do
          @path = 'tmp/tracks'
          subject.path = @path + '/more_tracks'
          FileUtils.mkpath subject.path
          File.open("#{subject.path}/mytrack", 'w') { |f| f.puts "file contents" }
          expect(subject).to be_valid
        end
      end
      context "as a path to an un-approved directory" do
        before do
          subject.path = @path = 'un_approved/tmp/tracks'
          FileUtils.mkpath @path
          File.open("#{@path}/mytrack", 'w') { |f| f.puts "file contents" }
        end

        it { should_not be_valid }

        it "should add :invalid translation to errors" do
          expect{
            subject.valid?
          }.to change(subject.errors, :size).by(1)
          expect(subject.errors[:path]).to include I18n.t('errors.messages.invalid')
        end
      end
    end

    context "as a path to a file" do
      context "in an approved directory" do
        it "should be valid" do
          file_path_with_file
          expect(subject).to be_valid
        end

        it "should be valid given a child directory of an approved parent" do
          @path = 'tmp/tracks'
          subject.path = @path + '/more_tracks/mytrack'
          FileUtils.mkpath @path + '/more_tracks'
          File.open("#{@path}/more_tracks/mytrack", 'w') { |f| f.puts "file contents" }
          expect(subject).to be_valid
        end
      end

      context "in an un-approved directory" do
        before do
          @path = 'un_approved/tmp/tracks'
          subject.path = @path + '/mytrack'
          FileUtils.mkpath @path
          File.open("#{@path}/mytrack", 'w') { |f| f.puts "file contents" }
        end

        it { should_not be_valid }

        it "should add :invalid translation to errors" do
          expect{
            subject.valid?
          }.to change(subject.errors, :size).by(1)
          expect(subject.errors[:path]).to include I18n.t('errors.messages.invalid')
        end
      end
    end
  end
end
