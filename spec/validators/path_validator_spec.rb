require 'spec_helper'

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

    before { subject.path = @path = 'tmp/mytrack' }

    context "with an existing path" do
      it "should be valid" do
        File.open(@path, 'w') { |f| f.puts "file contents" }
        expect(subject).to be_valid
      end
    end

    context "without an existing path" do
      it "should not be valid" do
        expect(subject).not_to be_valid
      end

      it "should add :exist translation to errors" do
        expect{
          subject.valid?
        }.to change(subject.errors, :size).by(1)
        expect(subject.errors[:path]).to include I18n.t('errors.messages.exist')
      end
    end
  end

  describe "optionally validates path is not empty" do
    before do
      subject.path = @path = 'tmp/mytrack'
      File.open(@path, 'w') { |f| f.puts "file contents" }
    end

    context "with option :allow_empty true" do
      before(:all) do
        class Validatable
          include ActiveModel::Validations
          attr_accessor :path
          validates_path_of :path, allow_empty: true
        end
      end
      after(:all) { Object.send(:remove_const, :Validatable) }

      it { should be_valid }

      it "should be valid with an empty path" do
        File.truncate(@path, 0)
        expect(subject).to be_valid
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

      it { should be_valid }

      context "with an empty path" do
        before { File.truncate(@path, 0) }

        it { should_not be_valid }

        it "should add :empty translation to errors" do
          expect{
            subject.valid?
          }.to change(subject.errors, :size).by(1)
          expect(subject.errors[:path]).to include I18n.t('errors.messages.empty')
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

      it { should be_valid }

      context "with an empty path" do
        before { File.truncate(@path, 0) }

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
    before do
      subject.path = @path = 'tmp/tracks'
    end

    context "with option :allow_directory true" do
      before(:all) do
        class Validatable
          include ActiveModel::Validations
          attr_accessor :path
          validates_path_of :path, allow_directory: true
        end
      end
      after(:all) { Object.send(:remove_const, :Validatable) }

      it "should be valid when path is a directory" do
        Dir.mkdir @path
        expect(subject).to be_valid
      end

      it "should be valid when path is a file" do
        subject.path = @path = 'tmp/mytrack'
        File.open(@path, 'w') { |f| f.puts "file contents" }
        expect(subject).to be_valid
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

      context "with a path that is a directory" do
        before { Dir.mkdir @path }

        it { should_not be_valid }

        it "should add :directory translation to errors" do
          expect{
            subject.valid?
          }.to change(subject.errors, :size).by(1)
          expect(subject.errors[:path]).to include I18n.t('errors.messages.directory')
        end
      end

      it "should be valid with path that is a file" do
        subject.path = @path = 'tmp/mytrack'
        File.open(@path, 'w') { |f| f.puts "file contents" }
        expect(subject).to be_valid
      end
    end

    context "option :allow_directory defaults to true" do
      before(:all) do
        class Validatable
          include ActiveModel::Validations
          attr_accessor :path
          validates_path_of :path
        end
      end
      after(:all) { Object.send(:remove_const, :Validatable) }

      it "should be valid with a path that is a directory" do
        Dir.mkdir @path
        expect(subject).to be_valid
      end
    end
  end
end
