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

      context "projects" do
        it { should be_able_to(:manage, Project) }
      end

      context "share_links" do
        it { should be_able_to(:manage, ShareLink) }
      end
    end

    describe "as manager" do
      before do
        @manager = FactoryGirl.create(:manager)
        @user = FactoryGirl.create(:user)
        @ability = Ability.new(@manager)
      end

      context "users" do
        it { should be_able_to(:invite, User) }
        it { should be_able_to(:cancel, @manager) }

        it { should_not be_able_to(:manage, @user) }
        it { should_not be_able_to(:cancel, @user) }
      end

      context "projects" do
        before do
          @project = FactoryGirl.create(:project, owner: @manager)
          @other_project = FactoryGirl.create(:project)
        end
        it { should_not be_able_to(:manage, @other_project) }
        it { should be_able_to(:manage, @project) }
      end

      context "groups" do
        before do
          @group = FactoryGirl.create(:group, owner: @manager)
          @other_group = FactoryGirl.create(:group)
        end
        it { should_not be_able_to(:manage, @other_group) }
        it { should be_able_to(:manage, @group) }
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

        it { should_not be_able_to(:manage, @other_user) }
        it { should_not be_able_to(:cancel, @other_user) }

        it { should be_able_to(:show, @user) }
        it { should be_able_to(:cancel, @user) }
      end

      context "groups" do
        before do
          @admin = FactoryGirl.create(:admin)
          @group = FactoryGirl.create(:group, owner: @admin)
        end

        it { should_not be_able_to(:manage, Group) }

        context "without being a member of the group" do
          it { should_not be_able_to(:manage, @group) }
          it { should_not be_able_to(:read, @group) }
        end

        context "being a member of the group" do
          before { @group.members << @user }

          it { should_not be_able_to(:manage, @group) }
          it { should be_able_to(:read, @group) }
        end
      end

      context "projects" do
        before do
          @user_on_project = FactoryGirl.create(:project, users: [@user])
          @other_user_project = FactoryGirl.create(:project, owner: @other_user)
        end

        it { should be_able_to(:user_access, @user_on_project) }
        it { should_not be_able_to(:manage, @user_on_project) }

        it { should_not be_able_to(:read, @other_user_project) }
        it { should_not be_able_to(:manage, @other_user_project) }
      end

      context "tracks" do
        before do
          @track = FactoryGirl.create(:test_track, project: FactoryGirl.create(:project))
        end

        it { should be_able_to(:read, Track, :project => { :user_ids => @user.id }) }

        it { should_not be_able_to(:read, @track) }
      end

      context "share_links" do
        before do
          @user_on_project = FactoryGirl.create(:project, users: [@user])
          @track = FactoryGirl.create(:test_track, project: @user_on_project)
          @share_link = FactoryGirl.create(:share_link, track: @track)
          @other_share_link = FactoryGirl.create(:share_link)
        end

        it { should be_able_to(:manage, ShareLink, :track => {:project => {:user_ids => @user.id }}) }

        it { should_not be_able_to(:manage, @other_share_link) }
      end
    end
  end
end
