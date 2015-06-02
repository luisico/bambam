require 'spec_helper'

describe User do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  describe "mixes in from Devise" do
    devise_modules = [:database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :invitable, :registerable]

    describe '#devise_modules' do
      subject { super().devise_modules }
      describe '#sort' do
        subject { super().sort }
        it { is_expected.to eq devise_modules.sort }
      end
    end
    devise_modules.each do |devise_module|
      describe '#devise_modules' do
        subject { super().devise_modules }
        it { is_expected.to include devise_module }
      end
    end

    Devise::Models.check_fields!(User)

    it_behaves_like "timestampable table"

    context "database authenticatable" do
      it { is_expected.to have_db_column :email }
      it { is_expected.to have_db_column :encrypted_password }
      it { is_expected.to have_db_index(:email).unique(true) }
      it { is_expected.to respond_to :email }
      it { is_expected.to respond_to :encrypted_password}
      it { is_expected.to respond_to :password }
      it { is_expected.to respond_to :password_confirmation }
    end

    context "recoverable" do
      it { is_expected.to have_db_column :reset_password_token }
      it { is_expected.to have_db_column :reset_password_sent_at }
      it { is_expected.to have_db_index(:reset_password_token).unique(true) }
      it { is_expected.to respond_to :reset_password_token }
      it { is_expected.to respond_to :reset_password_sent_at }
    end

    context "rememberable" do
      it { is_expected.to have_db_column :remember_created_at }
      it { is_expected.to respond_to :remember_created_at }
    end

    context "trackable" do
      it { is_expected.to have_db_column :sign_in_count }
      it { is_expected.to have_db_column :current_sign_in_at }
      it { is_expected.to have_db_column :last_sign_in_at }
      it { is_expected.to have_db_column :current_sign_in_ip }
      it { is_expected.to have_db_column :last_sign_in_ip }
      it { is_expected.to respond_to :sign_in_count }
      it { is_expected.to respond_to :current_sign_in_at }
      it { is_expected.to respond_to :last_sign_in_at }
      it { is_expected.to respond_to :current_sign_in_ip }
      it { is_expected.to respond_to :last_sign_in_ip }
    end

    context "invitable" do
      it { is_expected.to have_db_column :invitation_token }
      it { is_expected.to have_db_column :invitation_created_at }
      it { is_expected.to have_db_column :invitation_sent_at }
      it { is_expected.to have_db_column :invitation_accepted_at }
      it { is_expected.to have_db_column :invitation_limit }
      it { is_expected.to have_db_column :invited_by_type }
      it { is_expected.to have_db_column :invited_by_id }
      it { is_expected.to have_db_index(:invitation_token) }
      it { is_expected.to have_db_index(:invited_by_id) }
      it { is_expected.to respond_to :invitation_token }
      it { is_expected.to respond_to :invitation_created_at }
      it { is_expected.to respond_to :invitation_sent_at }
      it { is_expected.to respond_to :invitation_accepted_at }
      it { is_expected.to respond_to :invitation_limit }
      it { is_expected.to respond_to :invited_by }
    end
  end

  describe "mixes in from rolify" do
    it { is_expected.to have_and_belong_to_many :roles }
    it { is_expected.to respond_to :add_role }
    it { is_expected.to respond_to :has_role? }
  end

  describe "user name fields" do
    it { is_expected.to have_db_column :first_name }
    it { is_expected.to respond_to :first_name }
    it { is_expected.to have_db_column :last_name }
    it { is_expected.to respond_to :last_name }
    it { is_expected.to respond_to :handle }

    describe "#handle" do
      it "returns first name if there is only a first name" do
        user = FactoryGirl.create(:user, first_name: "Foo", last_name: "")
        expect(user.handle).to eq "Foo"
      end

      it "returns last name if there is only a last name" do
        user = FactoryGirl.create(:user, first_name: "", last_name: "Bar")
        expect(user.handle).to eq "Bar"
      end

      it "puts a space between first and last names" do
        user = FactoryGirl.create(:user, first_name: "Foo", last_name: "Bar")
        expect(user.handle).to eq "Foo Bar"
      end

      it "strips leading and trailing whitespace" do
        user = FactoryGirl.create(:user, first_name: " Foo ", last_name: "")
        expect(user.handle).to eq "Foo"
      end

      it "returns email when name first and last name are blank" do
        user = FactoryGirl.create(:user, first_name: "", last_name: "")
        expect(user.handle).to eq user.email
      end
    end

    describe "#handle_with_email" do
      it "returns just email when no name is present" do
        user = FactoryGirl.create(:user, first_name: "", last_name: "")
        expect(user.handle_with_email).to eq user.email
      end

      it "returns name followed by email in braces when name is present" do
        user = FactoryGirl.create(:user, first_name: "Foo", last_name: "Bar")
        expect(user.handle_with_email).to eq "Foo Bar [#{user.email}]"
      end
    end
  end

  it { is_expected.to be_valid }

  describe "email" do
    context "when blank" do
      it { is_expected.not_to allow_value(' ').for(:email) }
    end

    context "when format is invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        it { is_expected.not_to allow_value(address).for(:email) }
      end
    end

    context "when format is valid" do
      addresses = %w[user@foo.com A_USER@f.b.org frst.1st@foo.jp a+b@baz.cn]
      addresses.each do |address|
        it { is_expected.to allow_value(address).for(:email) }
      end
    end

    context "when already taken" do
      before do
        user_with_same_email = @user.dup
        user_with_same_email.save
      end
      it { is_expected.not_to be_valid }
    end

    context "when already taken regardless of case" do
      before do
        user_with_same_email = @user.dup
        user_with_same_email.email = @user.email.upcase
        user_with_same_email.save
      end
      it { is_expected.not_to be_valid }
    end
  end

  describe "password" do
    context "when blank" do
      before { @user.password = @user.password_confirmation = ' '}
      it { is_expected.not_to be_valid }
    end

    context "when doesn't match confirmation" do
      before { @user.password_confirmation = "mismatch" }
      it { is_expected.not_to be_valid }
    end

    context "when too short" do
      before { @user.password = @user.password_confirmation = 'a' * 7 }
      it { is_expected.not_to be_valid }
    end
  end

  describe "password encryption" do
    describe '#encrypted_password' do
      subject { super().encrypted_password }
      it { is_expected.not_to be_blank }
    end
  end

  describe "filter all users" do
    context "by user" do
      before { @users = FactoryGirl.create_list(:user, 3) }
      it "returns all users except indicated user" do
        expect(User.all_except(@user).sort).to eq @users.sort
        expect(User.all_except(@user)).not_to include @user
      end
    end
  end

  describe "associations" do
    context "memberships" do
      it { is_expected.to have_many :memberships }
      it { is_expected.to respond_to :memberships }
      it { is_expected.to respond_to :membership_ids }
    end

    context "groups" do
      it { is_expected.to have_many :groups }
      it { is_expected.to respond_to :groups }
      it { is_expected.to respond_to :group_ids }
    end

    context "projects_users" do
      it { is_expected.to have_many :projects_users }
      it { is_expected.to respond_to :projects_users }
      it { is_expected.to respond_to :projects_user_ids }
    end

    context "projects" do
      it { is_expected.to have_many :projects }
      it { is_expected.to respond_to :projects }
      it { is_expected.to respond_to :project_ids }
    end

    context "owned_projects" do
      it { is_expected.to have_many :owned_projects }
      it { is_expected.to respond_to :owned_projects }
      it { is_expected.to respond_to :owned_project_ids }
    end

    context "tracks" do
      it { is_expected.to have_many :tracks }
      it { is_expected.to respond_to :tracks }
      it { is_expected.to respond_to :track_ids }
    end

    context "datapaths" do
      it { is_expected.to have_many :datapaths }
      it { is_expected.to respond_to :datapaths }
      it { is_expected.to respond_to :datapath_ids }
    end

    context "datapaths_users" do
      it { is_expected.to have_many :datapaths_users }
      it { is_expected.to respond_to :datapaths_users }
      it { is_expected.to respond_to :datapaths_user_ids }
    end
  end

  describe "when user destroyed" do
    before do
      FactoryGirl.create(:group, members: [@user])
      FactoryGirl.create(:project, users: [@user])
      @user.save!
    end

    it "should destroy the user" do
      expect { @user.destroy }.to change(User, :count).by(-1)
      expect { User.find(@user.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "should destroy associated memberships" do
      expect { @user.destroy }.to change(Membership, :count).by(-1)
    end

    it "should destroy associated projects_users" do
      expect { @user.destroy }.to change(ProjectsUser, :count).by(-1)
    end
  end
end
