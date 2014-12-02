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

      context "projects_user" do
        it { should be_able_to(:update, ProjectsUser)}
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
        it { should     be_able_to(:manage, FactoryGirl.create(:project, owner: @manager)) }
        it { should_not be_able_to(:manage, FactoryGirl.create(:project)) }
      end

      context "groups" do
        it { should     be_able_to(:manage, FactoryGirl.create(:group, owner: @manager)) }
        it { should_not be_able_to(:manage, FactoryGirl.create(:group)) }
      end

      context "tracks" do
        before { @project = FactoryGirl.create(:project, owner: @manager) }

        it { should     be_able_to(:manage, FactoryGirl.create(:test_track, project: @project)) }
        it { should_not be_able_to(:manage, FactoryGirl.create(:test_track)) }
      end

      context "projects_user" do
        before do
          @project = FactoryGirl.create(:project, owner: @manager)
          @other_project = FactoryGirl.create(:project)
        end

        it { should     be_able_to(:update, @project.projects_users.first) }
        it { should_not be_able_to(:update, @other_project.projects_users.first) }
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
          @project = FactoryGirl.create(:project, users: [@user])
          @other_project = FactoryGirl.create(:project)

          @my_track = FactoryGirl.create(:test_track, owner: @user, project: @project)
          @project_track = FactoryGirl.create(:test_track, project: @project)
          @other_project_track = FactoryGirl.create(:test_track, project: @other_project)
        end

        it { should     be_able_to(:read, @my_track) }
        it { should     be_able_to(:read, @project_track) }
        it { should_not be_able_to(:read, @other_project_track) }

        it { should     be_able_to(:update, @my_track) }
        it { should_not be_able_to(:update, @project_track) }
        it { should_not be_able_to(:update, @other_project_track) }

        it { should     be_able_to(:destroy, @my_track) }
        it { should_not be_able_to(:destroy, @project_track) }
        it { should_not be_able_to(:destroy, @other_project_track) }

        it { should     be_able_to(:create, FactoryGirl.build(:test_track, project: @project)) }
        it { should_not be_able_to(:create, FactoryGirl.build(:test_track, project: @other_project)) }

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

      context "projects_user" do
        it { should_not be_able_to(:update, ProjectsUser) }
      end
    end
  end
end
