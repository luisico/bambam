require 'rails_helper'

RSpec.describe FilebrowserService do
  before { @path = File.join(TEST_BASE, 'mypath') }
  subject { FilebrowserService.new(@path) }

  describe "arguments" do
    it "raises error without arguments" do
      expect {FilebrowserService.new}.to raise_error ArgumentError
    end
  end

  describe "FORMATS" do
    it "defines file types to search for" do
      expect(FilebrowserService::FORMATS).to be_a Array
      expect(FilebrowserService::FORMATS).not_to be_empty
    end
  end

  describe "#path" do
    it "should be equal to @path" do
      expect(subject.path).to eq @path
    end
  end

  describe "#entries" do
    it "delegates to call if not set" do
      expect(subject).to receive(:call)
      subject.entries
    end

    it "returns entries without delagating to call if set" do
      expect(subject).not_to receive(:call)
      subject.instance_variable_set(:@entries, ['path1', 'path2'])
      expect(subject.entries).to eq ['path1', 'path2']
    end
  end

  describe "#call" do
    after { FileUtils.rm_rf(Dir[@path]) if File.exist?(@path) }

    it "sets the entries" do
      expect(Dir).to receive(:chdir).with(@path).and_yield
      expect(Dir).to receive(:glob).and_return ['path1', 'path2']

      subject.call
      expect(subject.instance_variable_get(:@entries)).to eq ['path1', 'path2']
    end

    it "returns entries based on allowed FORMATS" do
      dirs = ['dir1', 'dir2'].
        each {|dir| Pathname.new(File.join(@path, dir)).mkpath}

      files = ["track1.#{FilebrowserService::FORMATS.first}", 'another.file'].
        each {|file| Pathname.new(File.join(@path, file)).open("w") {}}

      expect(subject.call).to eq ['dir1/', 'dir2/', files.first]
    end

    it "return an empty array when path is not a directory" do
      Pathname.new(@path).mkpath
      Pathname.new(File.join(@path, 'file')).open("w") {}
      expect(subject.call).to eq []
    end

    it "raises error when path is not found" do
      expect {subject.call}.to raise_error Errno::ENOENT
    end
  end

  describe "#to_fancytree" do
    it "defaults to an empty array if there are no entries" do
      expect(subject).to receive(:entries).and_return []
      expect(subject.to_fancytree).to eq []
    end

    it "returns an array in fancytree format" do
      expect(subject).to receive(:entries).and_return ['dir1/', 'track1']
      expect(subject.to_fancytree).to eq [
        {title: "dir1", folder: true, lazy: true},
        {title: "track1"}
      ]
    end
  end
end
