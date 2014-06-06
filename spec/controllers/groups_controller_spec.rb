require 'spec_helper'

describe GroupsController do
  describe "GET 'index'" do
    before do
      @groups = FactoryGirl.create_list(:group, 2)
    end

    context "as a signed in user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should be successful" do
        get :index
        expect(response).to be_success
        expect(response).to render_template :index
      end

      it "should return all groups" do
        get :index
        expect(assigns(:groups)).to eq @groups
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :index
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "GET 'show'" do
    before { @group = FactoryGirl.create(:group) }

    context "as a signed in user" do
      before { sign_in FactoryGirl.create(:user) }

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

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :show, id: @group
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "GET 'new'" do
    context "as a signed in user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should be successful" do
        get :new
        expect(response).to be_success
        expect(response).to render_template :new
      end

      it "should build a new group" do
        get :new
        expect(assigns(:group)).to be_new_record
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
    before { @group = FactoryGirl.create(:group) }

    context "as a signed in user and owner of @group" do
      before { sign_in @group.owner }

      it "should be successful" do
        get :edit, id: @group
        expect(response).to be_success
        expect(response).to render_template :edit
      end

      it "should return the group" do
        get :edit, id: @group
        expect(assigns(:group)).to eq @group
      end
    end

    context "as a signed in user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should be denied" do
        get :edit, id: @group
        expect(response).not_to be_success
        expect(response).to redirect_to tracks_path
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

    context "as a signed in user" do
      before { sign_in FactoryGirl.create(:user) }

      context "with valid parameters" do
        it "should be a redirect to the new group show page" do
          post :create, group: @group_attr
          expect(response).to redirect_to group_path(Group.last)
        end

        it "should create a new group" do
          expect{
            post :create, group: @group_attr
          }.to change(Group, :count).by(1)
          expect(assigns(:group)).to eq Group.last
        end
      end

      context "with invalid parameters" do
        it "should render new template" do
          post :create, group: @group_attr.merge(name: '')
          expect(response).to be_success
          expect(response).to render_template :new
        end

        it "should not create a new group" do
          expect{
            post :create, group: @group_attr.merge(name: '')
          }.not_to change(Group, :count)
          expect(assigns(:group)).to be_new_record
        end
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        post :create, group: @group_attr
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end

      it "should not create a new group" do
        expect{
          post :create, group: @group_attr
        }.not_to change(Group, :count)
      end
    end
  end

  describe "Patch 'update'" do
    before { @group = FactoryGirl.create(:group) }

    context "as a signed in user and owner of @group" do
      before { sign_in @group.owner }

      context 'with valid parameters' do
        before do
          @new_group = FactoryGirl.attributes_for(:group)
        end

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

    context "as a signed in user" do
      before do
       sign_in FactoryGirl.create(:user)
       @new_group = FactoryGirl.attributes_for(:group)
     end

      it "should be denied" do
        patch :update, id: @group, group: @new_group
        expect(response).not_to be_success
        expect(response).to redirect_to tracks_path
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        patch :update, id: @group, group: {name: ''}
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end

      it "should not change the group's attributes" do
        expect{
          patch :update, id: @group, group: {name: ''}
        }.not_to change(@group, :name)
      end
    end
  end

  describe "Delete 'destroy'" do
    before { @group = FactoryGirl.create(:group) }

    context "as a signed in user and owner of @group" do
      before { sign_in @group.owner }

      it "should redirect to group#index" do
        delete :destroy, id: @group
        expect(response).to redirect_to groups_url
      end

      it "should delete the group" do
        expect{
          delete :destroy, id: @group
        }.to change(Group, :count).by(-1)
        expect(assigns(:group)).to eq @group
      end
    end

    context "as a signed in user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should be denied" do
        patch :destroy, id: @group
        expect(response).not_to be_success
        expect(response).to redirect_to tracks_path
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        delete :destroy, id: @group
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end

      it "should not delete the group" do
        expect{
          delete :destroy, id: @group
        }.not_to change(Group, :count)
      end
    end
  end
end

