# See https://github.com/thoughtbot/factory_girl/wiki/Testing-all-Factories-%28with-RSpec%29
require 'spec_helper'

describe 'validate FactoryGirl factories' do
  FactoryGirl.factories.each do |factory|
    context "with factory for :#{factory.name}" do
      unless factory.name == :track
        subject { FactoryGirl.build(factory.name) }

        it "is valid" do
          subject.valid?.should be, subject.errors.full_messages.join(", ")
        end
      end
    end
  end
end
