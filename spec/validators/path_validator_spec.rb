require 'spec_helper'

TEST_BASE = File.join 'tmp', 'tests'

def with_file(path)
  pathname = Pathname.new(path)
  dirname = pathname.dirname
  dirname.mkpath
  File.open(pathname, 'w') { |f| f.puts "file contents" }
  yield if block_given?
  ensure
    dirname.rmtree
end

def with_directory(path)
  dirname = Pathname.new(path)
  dirname.mkpath
  yield if block_given?
  ensure
    dirname.rmtree
end

describe ActiveModel::Validations::PathValidator do
  before(:all) do
     class ValidatableA
      include ActiveModel::Validations
      attr_accessor :path
    end
  end

  after(:all) {Pathname.new(TEST_BASE).rmtree }

  subject { Validatable.new }

  describe "remove tailing slashes from path before validation" do
    before(:all) do
      class Validatable < ValidatableA
        validates_path_of :path
      end
    end
    after(:all) { Object.send(:remove_const, :Validatable) }

    it "should remove trailing slash from path before validation" do
      subject.path = TEST_BASE + '/'
      expect{
        subject.valid?
      }.to change(subject, :path).to(TEST_BASE)
    end
  end

  describe "validates path exists in filesystem" do
    before(:all) do
      class Validatable < ValidatableA
        validates_path_of :path
      end
    end
    after(:all) { Object.send(:remove_const, :Validatable) }

    context "with an existing path containing a file" do
      it "should be valid" do
        subject.path = File.join TEST_BASE, 'dir1', 'file1'
        with_file(subject.path) { expect(subject).to be_valid }
      end
    end

    context "without an existing path" do
      before { subject.path = 'non_existing_path' }

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
    context "with option :allow_empty true" do
      before(:all) do
        class Validatable < ValidatableA
          validates_path_of :path, allow_empty: true
        end
      end
      after(:all) { Object.send(:remove_const, :Validatable) }

      context "as a path to a file" do
        before { subject.path = File.join TEST_BASE, 'dir1', 'file1' }

        it "should be valid" do
          with_file(subject.path) { expect(subject).to be_valid }
        end

        it "should be valid as an empty file" do
          with_file(subject.path) do
            File.truncate(subject.path, 0)
            expect(subject).to be_valid
          end
        end
      end

      context "as a path to a directory" do
        before { subject.path = File.join TEST_BASE, 'dir1' }

        it "should be valid as an empty directory" do
          with_directory(subject.path) { expect(subject).to be_valid }
        end

        it "should be valid as a non-empty directory" do
          with_directory(subject.path) do
            File.open(File.join(subject.path,'file1'), 'w') { |f| f.puts "file contents" }
            expect(subject).to be_valid
          end
        end
      end
    end

    context "with option :allow_empty false" do
      before(:all) do
        class Validatable < ValidatableA
          validates_path_of :path, allow_empty: false
        end
      end
      after(:all) { Object.send(:remove_const, :Validatable) }

      context "as a path to a file" do
        before { subject.path = File.join TEST_BASE, 'dir1', 'file1' }

        it "should be valid" do
          with_file(subject.path) { expect(subject).to be_valid }
        end

        context "as a path to an empty file" do
          it "should not be valid" do
            with_file(subject.path) do
              File.truncate(subject.path, 0)
              expect(subject).not_to be_valid
            end
          end

          it "should add :empty translation to errors" do
            with_file(subject.path) do
              File.truncate(subject.path, 0)
              expect{
                subject.valid?
              }.to change(subject.errors, :size).by(1)
              expect(subject.errors[:path]).to include I18n.t('errors.messages.empty')
            end
          end
        end
      end

      context "as a path to a directory" do
        before { subject.path = File.join TEST_BASE, 'dir1' }

        context "as an empty directory" do
          it "should not be valid" do
            with_directory(subject.path) { expect(subject).not_to be_valid }
          end

          it "should add :empty translation to errors" do
            with_directory(subject.path) do
              expect{
                subject.valid?
              }.to change(subject.errors, :size).by(1)
              expect(subject.errors[:path]).to include I18n.t('errors.messages.empty')
            end
          end
        end

        context "as a non-empty directory" do
          it "should be valid" do
            with_directory(subject.path) do
              File.open(File.join(subject.path,'file1'), 'w') { |f| f.puts "file contents" }
              expect(subject).to be_valid
            end
          end
        end
      end
    end

    context "option :allow_empty defaults to false" do
      before(:all) do
        class Validatable < ValidatableA
          validates_path_of :path
        end
      end
      after(:all) { Object.send(:remove_const, :Validatable) }

      context "as a path to an empty file" do
        before { subject.path = File.join TEST_BASE, 'dir1', 'file1' }

        it "should not be valid" do
          with_file(subject.path) do
            File.truncate(subject.path, 0)
            expect(subject).not_to be_valid
          end
        end

        it "should add :empty translation to errors" do
          with_file(subject.path) do
            File.truncate(subject.path, 0)
            expect{
              subject.valid?
            }.to change(subject.errors, :size).by(1)
            expect(subject.errors[:path]).to include I18n.t('errors.messages.empty')
          end
        end
      end

      context "as a path to an empty directory" do
        before { subject.path = File.join TEST_BASE, 'dir1' }

        it "should not be valid" do
          with_directory(subject.path) { expect(subject).not_to be_valid }
        end

        it "should add :empty translation to errors" do
          with_directory(subject.path) do
            expect{
              subject.valid?
            }.to change(subject.errors, :size).by(1)
            expect(subject.errors[:path]).to include I18n.t('errors.messages.empty')
          end
        end
      end
    end
  end

  describe "optionally validates path is not a directory" do
    context "with option :allow_directory true" do
      before(:all) do
        class Validatable < ValidatableA
          validates_path_of :path, allow_directory: true
        end
      end
      after(:all) { Object.send(:remove_const, :Validatable) }

      context "as a path to a file" do
        before { subject.path = File.join TEST_BASE, 'dir1', 'file1' }

        it "should be valid" do
          with_file(subject.path) { expect(subject).to be_valid }
        end

        context "as an empty file" do
          it "should not be valid" do
            with_file(subject.path) do
              File.truncate(subject.path, 0)
              expect(subject).not_to be_valid
            end
          end

          it "should add :empty translation to errors" do
            with_file(subject.path) do
              File.truncate(subject.path, 0)
              expect{
                subject.valid?
              }.to change(subject.errors, :size).by(1)
              expect(subject.errors[:path]).to include I18n.t('errors.messages.empty')
            end
          end
        end
      end

      context "as a path to directory" do
        before { subject.path = File.join TEST_BASE, 'dir1' }

        it "should be valid as a directory containing a file" do
          with_directory(subject.path) do
            File.open(File.join(subject.path,'file1'), 'w') { |f| f.puts "file contents" }
            expect(subject).to be_valid
          end
        end

        context "should not be valid as an empty directory" do
          it "should not be valid" do
            with_directory(subject.path) { expect(subject).not_to be_valid }
          end

          it "should add :empty translation to errors" do
            with_directory(subject.path) do
              expect{
                subject.valid?
              }.to change(subject.errors, :size).by(1)
              expect(subject.errors[:path]).to include I18n.t('errors.messages.empty')
            end
          end
        end
      end
    end

    context "with option :allow_directory true and :allow_empty true" do
      before(:all) do
        class Validatable < ValidatableA
          validates_path_of :path, allow_directory: true, allow_empty: true
        end
      end
      after(:all) { Object.send(:remove_const, :Validatable) }

      context "as a path to a file" do
        before { subject.path = File.join TEST_BASE, 'dir1', 'file1' }

        it "should be valid" do
          with_file(subject.path) { expect(subject).to be_valid }
        end

        it "should be valid as an empty file" do
          with_file(subject.path) do
            File.truncate(subject.path, 0)
            expect(subject).to be_valid
          end
        end
      end

      context "as a path to a directory" do
        before { subject.path = File.join TEST_BASE, 'dir1' }

        it "should be valid as an empty directory" do
          with_directory(subject.path) { expect(subject).to be_valid }
        end

        it "should be valid as a directory with a file" do
          with_directory(subject.path) do
            File.open(File.join(subject.path,'file1'), 'w') { |f| f.puts "file contents" }
            expect(subject).to be_valid
          end
        end
      end
    end

    context "with option :allow_directory false" do
      before(:all) do
        class Validatable < ValidatableA
          validates_path_of :path, allow_directory: false
        end
      end
      after(:all) { Object.send(:remove_const, :Validatable) }

      context "as a path to a file" do
        before { subject.path = File.join TEST_BASE, 'dir1', 'file1' }

        it "should be valid" do
          with_file(subject.path) { expect(subject).to be_valid }
        end
      end

      context "as a path to a directory" do
        before { subject.path = File.join TEST_BASE, 'dir1' }

        it "should not be valid" do
          with_directory(subject.path) { expect(subject).not_to be_valid }
        end

        it "should add :directory translation to errors" do
          with_directory(subject.path) do
            expect{
              subject.valid?
            }.to change(subject.errors, :size).by(1)
            expect(subject.errors[:path]).to include I18n.t('errors.messages.directory')
          end
        end
      end
    end

    context "with option :allow_directory false and :allow_empty true" do
      before(:all) do
        class Validatable < ValidatableA
          validates_path_of :path, allow_directory: false, allow_empty: true
        end
      end
      after(:all) { Object.send(:remove_const, :Validatable) }

      context "as a path to a file" do
        before { subject.path = File.join TEST_BASE, 'dir1', 'file1' }

        it "should be valid" do
          with_file(subject.path) { expect(subject).to be_valid }
        end

        it "should be valid as an empty file" do
          with_file(subject.path) do
            File.truncate(subject.path, 0)
            expect(subject).to be_valid
          end
        end
      end

      context "as a path to a directory" do
        before { subject.path = File.join TEST_BASE, 'dir1' }

        it "should not be valid as an empty directory" do
          with_directory(subject.path) { expect(subject).not_to be_valid }
        end

        it "should not be valid as a directory with a file" do
          with_directory(subject.path) do
            File.open(File.join(subject.path,'file1'), 'w') { |f| f.puts "file contents" }
            expect(subject).not_to be_valid
          end
        end
      end
    end
  end

  describe "optionally ensure that directory is pre-approved" do
    before(:all) do
      class Validatable < ValidatableA
        validates_path_of :path, within: [File.join(TEST_BASE, 'dir1')]
      end
    end
    after(:all) { Object.send(:remove_const, :Validatable) }

    context "as a path to a directory" do
      context "in an approved directory" do
        it "should be valid" do
          subject.path = File.join TEST_BASE, 'dir1'
          with_directory(subject.path) do
            File.open(File.join(subject.path,'file1'), 'w') { |f| f.puts "file contents" }
            expect(subject).to be_valid
          end
        end

        it "should be valid given a child directory of an approved parent" do
          subject.path = File.join TEST_BASE, 'dir1', 'subdir1'
          with_directory(subject.path) do
            File.open(File.join(subject.path,'file1'), 'w') { |f| f.puts "file contents" }
            expect(subject).to be_valid
          end
        end
      end

      context "in an un-approved directory" do
        before { subject.path = File.join 'un_approved', 'dir1', 'file1' }

        it "should not be valid" do
          with_directory(subject.path) do
            File.open(File.join(subject.path,'file1'), 'w') { |f| f.puts "file contents" }
            expect(subject).not_to be_valid
          end
        end

        it "should add :invalid translation to errors" do
          with_directory(subject.path) do
            File.open(File.join(subject.path,'file1'), 'w') { |f| f.puts "file contents" }
            expect{
              subject.valid?
            }.to change(subject.errors, :size).by(1)
            expect(subject.errors[:path]).to include I18n.t('errors.messages.invalid')
          end
        end
      end
    end
  end
end
