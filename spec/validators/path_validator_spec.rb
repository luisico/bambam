require 'spec_helper'

TEST_BASE = File.join Rails.root, 'tmp', 'tests'

def with_file(path, empty=false)
  pathname = Pathname.new(path)
  dirname = pathname.dirname
  cp_track pathname
  pathname.truncate(0) if empty
  yield if block_given?
ensure
  dirname.rmtree
end

def with_empty_file(path)
  with_file(path, true, &Proc.new)
end

def with_directory(path)
  dirname = Pathname.new(path)
  dirname.mkpath
  yield if block_given?
ensure
  dirname.cleanpath.rmtree
end

describe ActiveModel::Validations::PathValidator do
  before(:all) do
    class ValidatableA
      include ActiveModel::Validations
      attr_accessor :path
    end
  end

  after(:all) { Pathname.new(TEST_BASE).exist? && Pathname.new(TEST_BASE).rmtree}

  subject { Validatable.new }

  describe "default behavoir" do
    before(:all) do
      class Validatable < ValidatableA
        validates_path_of :path
      end
    end
    after(:all) { Object.send(:remove_const, :Validatable) }

    [nil, ''].each do |blank_value|
      context "does not allow #{blank_value.inspect} values" do
        before { subject.path = blank_value }

        it "should not be valid" do
          expect(subject).not_to be_valid
        end

        it "should add :exist translation to errors" do
          expect{
            subject.valid?
          }.to change(subject.errors, :size).by(1)
          expect(subject.errors[:path]).to include I18n.t('errors.messages.blank')
        end
      end
    end

    it "removes redirection from pathname" do
      [
        ['..',                        TEST_BASE],
        [File.join('..', '..'),       File.join(Rails.root, 'tmp')],
        [File.join('..', '..', '..'), File.join(Rails.root)],
      ].each do |item|
        subject.path = File.join TEST_BASE, 'dir1', item[0]
        expect{
          subject.valid?
        }.to change(subject, :path).to(item[1])
      end
    end

    it "should remove trailing slash from path before validation" do
      subject.path = TEST_BASE + '/'
      expect{
        subject.valid?
      }.to change(subject, :path).to(TEST_BASE)
    end

    it "should remove leading and trailing whitespace from path before validation" do
      subject.path = ' '+ TEST_BASE + ' '
      expect{
        subject.valid?
      }.to change(subject, :path).to(TEST_BASE)
    end

    context "validates path exists in filesystem" do
      context "with an existing path" do
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

    context "only allows files and directories" do
      before do
        subject.path = File.join TEST_BASE, 'weird-ftype'
        expect(File).to receive(:file?).and_return(false)
        expect(File).to receive(:directory?).and_return(false)
        expect(File).to receive(:exist?).and_return(true)
      end

      it "should not be valid" do
        expect(subject).not_to be_valid
      end

      it "should add :exist translation to errors" do
        expect{
          subject.valid?
        }.to change(subject.errors, :size)
        expect(subject.errors[:path]).to include I18n.t('errors.messages.ftype')
      end
    end

    context "options" do
      it ":allow_empty defaults to 'false'" do
        validator = subject._validators[:path].first
        expect( validator.send(:allow_empty?) ).to be_false
      end

      it ":allow_directory defaults to 'true'" do
        validator = subject._validators[:path].first
        expect( validator.send(:allow_directory?) ).to be_true
      end
    end
  end

  describe "option :allow_empty" do
    context "'true'" do
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

        it "should be valid when file is empty" do
          with_empty_file(subject.path) { expect(subject).to be_valid }
        end
      end

      context "as a path to a directory" do
        before { subject.path = File.join TEST_BASE, 'dir1' }

        it "should be valid when directory is empty" do
          with_directory(subject.path) { expect(subject).to be_valid }
        end

        it "should be valid when directory is not empty" do
          with_file(File.join(subject.path,'file1')) { expect(subject).to be_valid }
        end
      end
    end

    context "'false'" do
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

        context "when empty" do
          it "should not be valid" do
            with_empty_file(subject.path) { expect(subject).not_to be_valid }
          end

          it "should add :empty translation to errors" do
            with_empty_file(subject.path) do
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

        context "when empty" do
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

        it "when not empty should be valid" do
          with_file(File.join(subject.path,'file1')) { expect(subject).to be_valid }
        end
      end
    end
  end

  describe "option :allow_directory" do
    context "'true'" do
      before(:all) do
        class Validatable < ValidatableA
          validates_path_of :path, allow_directory: true
        end
      end
      after(:all) { Object.send(:remove_const, :Validatable) }

      before { subject.path = File.join TEST_BASE, 'dir1' }

      it "should be valid as a directory containing a file" do
        with_file(File.join(subject.path,'file1')) { expect(subject).to be_valid }
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

    context "'false'" do
      before(:all) do
        class Validatable < ValidatableA
          validates_path_of :path, allow_directory: false
        end
      end
      after(:all) { Object.send(:remove_const, :Validatable) }

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

  describe "option :within" do
    before(:all) do
      class Validatable < ValidatableA
        validates_path_of :path, within: [File.join(TEST_BASE, 'dir1'), File.join(TEST_BASE, 'dir2')]
      end
    end
    after(:all) { Object.send(:remove_const, :Validatable) }

    context "in an approved directory" do
      it "itself should be valid if it is not empty" do
        subject.path = File.join TEST_BASE, 'dir1'
        with_file(File.join(subject.path, 'file1')) { expect(subject).to be_valid }
      end

       it "a file deep in the directory should be valid" do
        subject.path = File.join TEST_BASE, 'dir1', 'subdir1', 'file1'
        with_file(subject.path) { expect(subject).to be_valid }
      end
    end

    context "in an un-approved directory" do
      before { subject.path = File.join 'un_approved', 'file1' }

      it "should not be valid" do
        with_file(subject.path) { expect(subject).not_to be_valid }
      end

      it "should add :invalid translation to errors" do
        with_file(subject.path) do
          expect{
            subject.valid?
          }.to change(subject.errors, :size).by(1)
          expect(subject.errors[:path]).to include I18n.t('errors.messages.inclusion')
        end
      end
    end

    context "in an un-approved directory that initially matches approved path" do
      before { subject.path = File.join TEST_BASE, 'dir1', '..', 'dir3' }

      it "should not be valid" do
        with_directory(subject.path) { expect(subject).not_to be_valid }
      end

      it "should add :invalid translation to errors" do
        with_directory(subject.path) do
          expect{
            subject.valid?
          }.to change(subject.errors, :size).by(1)
          expect(subject.errors[:path]).to include I18n.t('errors.messages.inclusion')
        end
      end
    end
  end

  describe "option :in is an alias for :witin" do
    it "should reject a file not included" do
      class Validatable < ValidatableA
        validates_path_of :path, in: [File.join(TEST_BASE, 'dir3')]
      end

      subject.path = File.join TEST_BASE, 'dir4'
      with_file(subject.path) { expect(subject).not_to be_valid }
      expect(subject.errors[:path]).to include I18n.t('errors.messages.inclusion')

      Object.send(:remove_const, :Validatable)
    end
  end
end
