require 'spec_helper'

describe User do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  describe "mixes in from Devise" do
    devise_modules = [:database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :invitable, :registerable]
    its("devise_modules.sort") { should eq devise_modules.sort }
    devise_modules.each do |devise_module|
      its(:devise_modules) { should include devise_module }
    end

    Devise::Models.check_fields!(User)

    it_behaves_like "timestampable table"

    context "database authenticatable" do
      it { should have_db_column :email }
      it { should have_db_column :encrypted_password }
      it { should have_db_index(:email).unique(true) }
      it { should respond_to :email }
      it { should respond_to :encrypted_password}
      it { should respond_to :password }
      it { should respond_to :password_confirmation }
    end

    context "recoverable" do
      it { should have_db_column :reset_password_token }
      it { should have_db_column :reset_password_sent_at }
      it { should have_db_index(:reset_password_token).unique(true) }
      it { should respond_to :reset_password_token }
      it { should respond_to :reset_password_sent_at }
    end

    context "rememberable" do
      it { should have_db_column :remember_created_at }
      it { should respond_to :remember_created_at }
    end

    context "trackable" do
      it { should have_db_column :sign_in_count }
      it { should have_db_column :current_sign_in_at }
      it { should have_db_column :last_sign_in_at }
      it { should have_db_column :current_sign_in_ip }
      it { should have_db_column :last_sign_in_ip }
      it { should respond_to :sign_in_count }
      it { should respond_to :current_sign_in_at }
      it { should respond_to :last_sign_in_at }
      it { should respond_to :current_sign_in_ip }
      it { should respond_to :last_sign_in_ip }
    end

    context "invitable" do
      it { should have_db_column :invitation_token }
      it { should have_db_column :invitation_created_at }
      it { should have_db_column :invitation_sent_at }
      it { should have_db_column :invitation_accepted_at }
      it { should have_db_column :invitation_limit }
      it { should have_db_column :invited_by_type }
      it { should have_db_column :invited_by_id }
      it { should have_db_index(:invitation_token) }
      it { should have_db_index(:invited_by_id) }
      it { should respond_to :invitation_token }
      it { should respond_to :invitation_created_at }
      it { should respond_to :invitation_sent_at }
      it { should respond_to :invitation_accepted_at }
      it { should respond_to :invitation_limit }
      it { should respond_to :invited_by }
    end
  end

  describe "mixes in from rolify" do
    it { should have_and_belong_to_many :roles }
    it { should respond_to :add_role }
    it { should respond_to :has_role? }
  end

  describe "user name fields" do
    it { should have_db_column :first_name }
    it { should respond_to :first_name }
    it { should have_db_column :last_name }
    it { should respond_to :last_name }
  end

  it { should be_valid }

  describe "email" do
    context "when blank" do
      it { should_not allow_value(' ').for(:email) }
    end

    context "when format is invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        it { should_not allow_value(address).for(:email) }
      end
    end

    context "when format is valid" do
      addresses = %w[user@foo.com A_USER@f.b.org frst.1st@foo.jp a+b@baz.cn]
      addresses.each do |address|
        it { should allow_value(address).for(:email) }
      end
    end

    context "when already taken" do
      before do
        user_with_same_email = @user.dup
        user_with_same_email.save
      end
      it { should_not be_valid }
    end

    context "when already taken regardless of case" do
      before do
        user_with_same_email = @user.dup
        user_with_same_email.email = @user.email.upcase
        user_with_same_email.save
      end
      it { should_not be_valid }
    end
  end

  describe "password" do
    context "when blank" do
      before { @user.password = @user.password_confirmation = ' '}
      it { should_not be_valid }
    end

    context "when doesn't match confirmation" do
      before { @user.password_confirmation = "mismatch" }
      it { should_not be_valid }
    end

    context "when too short" do
      before { @user.password = @user.password_confirmation = 'a' * 7 }
      it { should_not be_valid }
    end
  end

  describe "password encryption" do
    its(:encrypted_password) { should_not be_blank }
  end

  describe "filter all users" do
    context "by user" do
      before { @users = FactoryGirl.create_list(:user, 3) }
      it "returns all users except indicated user" do
        expect(User.all_except(@user)).to eq @users
        expect(User.all_except(@user)).not_to include @user
      end
    end
  end

  describe "associations" do
    context "memberships" do
      it { should have_many :memberships }
      it { should respond_to :memberships }
      it { should respond_to :membership_ids }
    end

    context "groups" do
      it { should have_many :groups }
      it { should respond_to :groups }
      it { should respond_to :group_ids }
    end

    context "projects_users" do
      it { should have_many :projects_users }
      it { should respond_to :projects_users }
      it { should respond_to :projects_user_ids }
    end

    context "projects" do
      it { should have_many :projects }
      it { should respond_to :projects }
      it { should respond_to :project_ids }
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
