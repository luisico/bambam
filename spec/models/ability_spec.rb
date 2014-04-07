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

    describe "as inviter" do
      before do
        @inviter = FactoryGirl.create(:inviter)
        @ability = Ability.new(@inviter)
      end

      subject { @ability }

      context "users" do
        it { should be_able_to(:manage, User) }
      end
    end

    describe "as a regular user" do
      before do
        @user = FactoryGirl.create(:user)
        @other_user = FactoryGirl.create(:user)
        @ability = Ability.new(@user)
      end

      subject { @ability }

      context "users" do
        it { should_not be_able_to(:manage, User) }

        it { should_not be_able_to(:manage, @other_user)}
        it { should_not be_able_to(:cancel, @other_user) }

        it { should be_able_to(:show, @user) }
        it { should be_able_to(:cancel, @user) }
      end
    end
  end
end