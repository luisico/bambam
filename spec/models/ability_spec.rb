require 'spec_helper'
require 'cancan/matchers'

describe User do
  describe "abilities" do
    subject { @ability }

    describe "as admin" do
      before do
        @admin = FactoryGirl.create(:admin)
        @ability = Ability.new(@admin)
      end

      context "users" do
        it { should be_able_to(:manage, User) }
      end

      context "tracks" do
        it { should be_able_to(:manage, Track) }
      end

      context "groups" do
        it { should be_able_to(:manage, Group) }
      end
    end

    describe "as inviter" do
      before do
        @inviter = FactoryGirl.create(:inviter)
        @user = FactoryGirl.create(:user)
        @ability = Ability.new(@inviter)
      end

      context "users" do
        it { should be_able_to(:invite, User) }
        it { should be_able_to(:cancel, @inviter) }

        it { should_not be_able_to(:manage, @user) }
        it { should_not be_able_to(:cancel, @user) }
      end

      context "tracks" do
        it { should be_able_to(:manage, Track) }
      end

      context "groups" do
        before { @inviter_group = FactoryGirl.create(:group, owner: @inviter) }
        it { should be_able_to(:read, Group) }
        it { should be_able_to(:manage, @inviter_group)}
      end
    end

    describe "as a regular user" do
      before do
        @user = FactoryGirl.create(:user)
        @other_user = FactoryGirl.create(:user)
        @ability = Ability.new(@user)
      end

      context "users" do
        it { should_not be_able_to(:manage, User) }

        it { should_not be_able_to(:manage, @other_user)}
        it { should_not be_able_to(:cancel, @other_user) }

        it { should be_able_to(:show, @user) }
        it { should be_able_to(:cancel, @user) }
      end

      context "tracks" do
        it { should be_able_to(:manage, Track) }
      end

      context "groups" do
        before { @user_group = FactoryGirl.create(:group, owner: @user) }
        it { should be_able_to(:read, Group) }
        it { should be_able_to(:manage, @user_group)}
      end
    end
  end
end
