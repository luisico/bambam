require 'spec_helper'

describe GroupsController do
  describe "GET 'index'" do
    before do
      @groups = FactoryGirl.create_list(:group, 2)
    end

    context "as a signed in user" do
      before { sign_in FactoryGirl.create(:user, :groups => [@groups.first]) }

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
      before { sign_in FactoryGirl.create(:user, :groups => [@group]) }

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

  describe "Post 'create'" do
    before do
      @group_attr = FactoryGirl.attributes_for(:group)
      @another_user = FactoryGirl.create(:user)
    end

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
end

