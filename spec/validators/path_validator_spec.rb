require 'spec_helper'

describe ActiveModel::Validations::PathValidator do
  subject { Validatable.new }

  describe "validates path exists in filesystem" do
    class Validatable
      include ActiveModel::Validations
      attr_accessor :path
      validates_path_of :path
    end

    context "with an existing path" do
      before do
        @path = 'tmp/mytrack'
        File.open(@path, 'w') { |f| f.puts "file contents" }
      end

      after { File.unlink(@path) if File.exist?(@path) }

      it "should be valid" do
        subject.path = @path
        expect(subject).to be_valid
      end
    end

    context "without an existing path" do
      before do
        @path = 'tmp/mytrack'
      end

      it "should not be valid" do
        subject.path = @path
        expect(subject).not_to be_valid
      end

      it "should add :exist translation to errors" do
        subject.path = @path
        expect{
          subject.valid?
        }.to change(subject.errors, :size).by(1)
        expect(subject.errors[:path]).to include I18n.t('errors.messages.exist')
      end
    end
  end
end
