require 'spec_helper'

describe DatapathsController do
  before { @admin = FactoryGirl.create(:admin) }

  describe "GET 'index'" do
    before { @datapaths = FactoryGirl.create_list(:test_datapath, 3) }

    context "as an admin" do
      before { sign_in @admin }

      it "should be successful" do
        get :index
        expect(response).to be_success
        expect(response).to render_template :index
      end

      it "should return all datapaths" do
        get :index
        expect(assigns(:datapaths)).to eq @datapaths
      end
    end

    context "as regular user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should be denied" do
        get :index
        expect(response).not_to be_success
        expect(response).to redirect_to projects_path
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

  describe "Post 'create'" do
    before do
      @datapath_attr = FactoryGirl.attributes_for(:test_datapath)
      Pathname.new(@datapath_attr[:path]).mkpath unless File.exist?(@datapath_attr[:path])
    end

    context "as an admin" do
      before { sign_in FactoryGirl.create(:admin) }

      context "with valid parameters" do
        it "should be a success" do
          post :create, datapath: @datapath_attr, format: 'js'
          expect(response).to be_success
        end

        it "should create a new datapath" do
          expect{
            post :create, datapath: @datapath_attr, format: 'js'
          }.to change(Datapath, :count).by(1)
        end
      end

      context "with invalid parameters" do
        it "should not create a new datapath" do
          expect{
            post :create, datapath: @datapath_attr.merge(path: ""), format: 'js'
          }.not_to change(Datapath, :count)
        end
      end
    end

    context "as a signed in user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should return forbidden" do
        post :create, datapath: @datapath_attr, format: 'js'
        expect(response).not_to be_success
        expect(response.status).to be 403
        expect(response).not_to redirect_to(projects_path)
      end

      it "should not create a new datapath" do
        expect{
          post :create, datapath: @datapath_attr, format: 'js'
        }.not_to change(Datapath, :count)
      end
    end

    context "as a visitor" do
      it "should return unauthorized response" do
        post :create, datapath: @datapath_attr, format: 'js'
        expect(response).not_to be_success
        expect(response.status).to be 401
      end

      it "should not create a new datapath" do
        expect{
          post :create, datapath: @datapath_attr, format: 'js'
        }.not_to change(Datapath, :count)
      end
    end
  end

  describe "Delete 'destroy'" do
    before { @datapath = FactoryGirl.create(:test_datapath) }

    context "as an admin" do
      before { sign_in @admin}

      it "should be a success" do
        delete :destroy, id: @datapath, format: 'js'
        expect(response).to be_success
      end

      it "should delete the share link" do
        expect{
          delete :destroy, id: @datapath, format: 'js'
        }.to change(Datapath, :count).by(-1)
        expect(assigns(:datapath)).to eq @datapath
      end
    end

    context "as an admin" do
      before { sign_in @admin}

      it "should be a success" do
        delete :destroy, id: @datapath, format: 'js'
        expect(response).to be_success
      end

      it "should delete the share link" do
        expect{
          delete :destroy, id: @datapath, format: 'js'
        }.to change(Datapath, :count).by(-1)
        expect(assigns(:datapath)).to eq @datapath
      end
    end

    context "as a signed in user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should return forbidden" do
        delete :destroy, id: @datapath, format: 'js'
        expect(response).not_to be_success
        expect(response.status).to be 403
        expect(response).not_to redirect_to(projects_path)
      end

      it "should not delete the datapath" do
        expect{
          delete :destroy, id: @datapath, format: 'js'
        }.not_to change(Datapath, :count)
      end
    end

    context "as a visitor" do
      it "should return unauthorized" do
        delete :destroy, id: @datapath, format: 'js'
        expect(response).not_to be_success
        expect(response.status).to be 401
      end

      it "should not delete the datapath" do
        expect{
          delete :destroy, id: @datapath, format: 'js'
        }.not_to change(Datapath, :count)
      end
    end
  end
end
