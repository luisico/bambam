require 'rails_helper'

# See https://github.com/thoughtbot/factory_girl/wiki/Testing-all-Factories-%28with-RSpec%29
RSpec.describe 'validate FactoryGirl factories' do
  FactoryGirl.factories.each do |factory|
    context "with factory for :#{factory.name}" do
      unless factory.name =~ /^seeded_/
        subject { FactoryGirl.build(factory.name) }

        it "is valid" do
          expect(subject.valid?).to be, subject.errors.full_messages.join(", ")
        end
      end
    end
  end
end
