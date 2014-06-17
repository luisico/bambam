require 'spec_helper'

describe GroupsController do
  describe "GET 'show'" do
    before { @group = FactoryGirl.create(:group) }

    context "as a user" do
      context "as an admin" do
        before { sign_in FactoryGirl.create(:admin) }

        it "should be successful" do
          get :show, id: @group
          expect(response).to be_success
          expect(response).to render_template :show
        end

        it "should return the group" do
          get :show, id: @group
          expect(assigns(:group)).to eq @group
        end
      end

      context "as a group member" do
        before { sign_in FactoryGirl.create(:user, groups: [@group]) }

        it "should be successful" do
          get :show, id: @group
          expect(response).to be_success
          expect(response).to render_template :show
        end

        it "should return the group" do
          get :show, id: @group
          expect(assigns(:group)).to eq @group
        end
      end

      context "as a non group member" do
        it "should be denied" do
          sign_in FactoryGirl.create(:user)
          get :show, id: @group
          expect(response).not_to be_success
          expect(response).to redirect_to tracks_path
        end
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :show, id: @group
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "GET 'new'" do
    context "as an admin" do
      before do
        @admin = FactoryGirl.create(:admin)
        sign_in @admin
      end

      it "should be successful" do
        get :new
        expect(response).to be_success
        expect(response).to render_template :new
      end

      it "should build a new group" do
        get :new
        expect(assigns(:group)).to be_new_record
        expect(assigns(:group)).to be_kind_of Group
      end

      it "should assign ownership to signed in user" do
        get :new
        expect(assigns(:group).owner).to eq @admin
      end

      it "should add signed in user to members" do
        get :new
        expect(assigns(:group).members).to include @admin
      end

      it "should assign potential members" do
        get :new
        expect(assigns(:potential_members)).not_to be_empty
      end
    end

    context "as a user" do
      it "should be denied" do
        sign_in FactoryGirl.create(:user)
        get :new
        expect(response).not_to be_success
        expect(response).to redirect_to tracks_path
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :new
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "GET 'edit'" do
    before do
      @admin = FactoryGirl.create(:admin)
      @group = FactoryGirl.create(:group, owner: @admin)
    end

    context "as an admin and owner of group" do
      before { sign_in @admin }

      it "should be successful" do
        get :edit, id: @group
        expect(response).to be_success
        expect(response).to render_template :edit
      end

      it "should return the group" do
        get :edit, id: @group
        expect(assigns(:group)).to eq @group
      end

      it "should assign potential members" do
        get :edit, id: @group
        expect(assigns(:potential_members)).not_to be_empty
      end
    end

    context "as a user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should be denied" do
        get :edit, id: @group
        expect(response).not_to be_success
        expect(response).to redirect_to projects_path
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :edit, id: @group
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "Post 'create'" do
    before { @group_attr = FactoryGirl.attributes_for(:group) }

    context "as an admin" do
      before do
        @admin = FactoryGirl.create(:admin)
        sign_in @admin
      end

      context "with valid parameters" do
        it "should be a redirect to the new group show page" do
          post :create, group: @group_attr
          expect(response).to redirect_to group_path(Group.last)
        end

        it "should create a new group" do
          expect {
            post :create, group: @group_attr
          }.to change(Group, :count).by(1)
          expect(assigns(:group)).to eq Group.last
        end

        it "should assign ownership to signed in user" do
          post :create, group: @group_attr
          expect(assigns(:group).owner).to eq @admin
        end

        it "should add signed in user to members" do
          post :create, group: @group_attr
          expect(assigns(:group).members).to include @admin
        end
      end

      context "with invalid parameters" do
        it "should render new template" do
          post :create, group: @group_attr.merge(name: '')
          expect(response).to be_success
          expect(response).to render_template :new
        end

        it "should not create a new group" do
          expect {
            post :create, group: @group_attr.merge(name: '')
          }.not_to change(Group, :count)
          expect(assigns(:group)).to be_new_record
        end

        it "should assign potential members" do
          post :create, group: @group_attr.merge(name: '')
          expect(assigns(:potential_members)).not_to be_empty
        end
      end
    end

    context "as a user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should be denied" do
        post :create, group: @group_attr
        expect(response).not_to be_success
        expect(response).to redirect_to tracks_path
      end

      it "should not create a new group" do
        expect {
          post :create, group: @group_attr
        }.not_to change(Group, :count)
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        post :create, group: @group_attr
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end

      it "should not create a new group" do
        expect {
          post :create, group: @group_attr
        }.not_to change(Group, :count)
      end
    end
  end

  describe "Patch 'update'" do
    before do
      @admin = FactoryGirl.create(:admin)
      @group = FactoryGirl.create(:group, owner: @admin)
    end

    context "as an admin and owner of group" do
      before { sign_in @admin }

      context 'with valid parameters' do
        before { @new_group = FactoryGirl.attributes_for(:group) }

        it "should redirect to the updated show page" do
          patch :update, id: @group, group: @new_group
          expect(response).to redirect_to @group
        end

        it "should update the group" do
          patch :update, id: @group, group: @new_group
          @group.reload
          expect(assigns(:group)).to eq @group
          expect(@group.name).to eq @new_group[:name]
        end

        it "should not change ownership" do
          expect {
            patch :update, id: @group, group: @new_group
          }.not_to change(@group, :owner)
        end

        it "should add owner to members if not present" do
          patch :update, id: @group, group: @new_group.merge(member_ids: [])
          expect(assigns(:group).members).to include @group.owner
        end
      end

      context "with invalid parameters" do
        it "should render the edit template" do
          patch :update, id: @group, group: {name: ''}
          expect(response).to be_success
          expect(response).to render_template :edit
        end

        it "should not change the group's attributes" do
          expect {
            patch :update, id: @group, group: {name: ''}
            @group.reload
          }.not_to change(@group, :name)
          expect(assigns(:group)).to eq @group
        end
      end
    end

    context "as an admin" do
      before do
       @user = FactoryGirl.create(:admin)
       sign_in @user
       @new_group = FactoryGirl.attributes_for(:group)
     end

      it "should not change ownership" do
        expect {
          patch :update, id: @group, group: @new_group
        }.not_to change(@group, :owner)
      end

      it "should add owner to members if not present" do
        patch :update, id: @group, group: @new_group.merge(member_ids: [])
        expect(assigns(:group).members).to include @group.owner
      end

      it "should not add admin to members" do
        patch :update, id: @group, group: @new_group.merge(member_ids: [])
        expect(assigns(:group).members).not_to include @user
      end
    end

    context "as a user" do
      before do
       sign_in FactoryGirl.create(:user)
       @new_group = FactoryGirl.attributes_for(:group)
     end

      it "should be denied" do
        patch :update, id: @group, group: @new_group
        expect(response).not_to be_success
        expect(response).to redirect_to projects_path
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        patch :update, id: @group, group: {name: 'new track name'}
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end

      it "should not change the group's attributes" do
        expect {
          patch :update, id: @group, group: {name: ''}
        }.not_to change(@group, :name)
      end
    end
  end

  describe "Delete 'destroy'" do
    before do
      @admin = FactoryGirl.create(:admin)
      @group = FactoryGirl.create(:group, owner: @admin)
    end

    context "as an admin" do
      before { sign_in @admin }

      it "should redirect to users page" do
        delete :destroy, id: @group
        expect(response).to redirect_to users_path
      end

      it "should delete the group" do
        expect {
          delete :destroy, id: @group
        }.to change(Group, :count).by(-1)
        expect(assigns(:group)).to eq @group
      end

      it "should not delete owner or members" do
        expect {
          delete :destroy, id: @group
        }.not_to change(User, :count)
      end

    end

    context "as a user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should be denied" do
        patch :destroy, id: @group
        expect(response).not_to be_success
        expect(response).to redirect_to projects_path
      end

      it "should not delete the group" do
        expect {
          delete :destroy, id: @group
        }.not_to change(Group, :count)
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        delete :destroy, id: @group
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end

      it "should not delete the group" do
        expect {
          delete :destroy, id: @group
        }.not_to change(Group, :count)
      end
    end
  end

  describe "#potential_members" do
    before do
      @owner = FactoryGirl.create(:user)
      @members = FactoryGirl.create_list(:user, 2)
      @users = FactoryGirl.create_list(:user, 2)
      @group = FactoryGirl.create(:group, owner: @owner, members: @members)
    end

    it "should return the owner first" do
      expect(controller.send(:potential_members, @group).first).to eq @owner
    end

    it "should return the owner only once" do
      selected = controller.send(:potential_members, @group).select{|m| m == @owner}
      expect(selected.count).to eq 1
    end
  end
end
