require 'spec_helper'
require 'cancan/matchers'

describe User do
  describe "abilities" do
    describe "as admin" do
      before do
        @admin = FactoryGirl.create(:admin)
        @ability = Ability.new(@admin)
      end

      subject { @ability }

      context "users" do
        it { should be_able_to(:manage, User) }
      end
    end

    describe "as a regular user" do
      before do
        @user = FactoryGirl.create(:user)
        @ability = Ability.new(@user)
      end

      subject { @ability }

      context "users" do
        it { should_not be_able_to(:manage, User) }
      end
    end
  end
end
