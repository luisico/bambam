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

    context "as a manager" do
      before { sign_in FactoryGirl.create(:manager) }

      it "should be denied" do
        get :index
        expect(response).not_to be_success
        expect(response).to redirect_to projects_path
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

  describe "GET 'new'" do
    context "as an admin" do
      before { sign_in @admin }

      it "should be successful" do
        get :new, format: 'js'
        expect(response).to be_success
        expect(response).to render_template :new
      end

      it "should build a new share link" do
        get :new, format: 'js'
        expect(assigns(:datapath)).to be_new_record
      end

      it "should not respond html" do
        expect {
          get :new, format: 'html'
        }.to raise_error ActionView::MissingTemplate
      end
    end

    context "as a manager" do
      before { sign_in FactoryGirl.create(:manager) }

      it "should return forbidden" do
        get :new, format: 'js'
        expect(response).not_to be_success
        expect(response.status).to be 403
        expect(response).not_to redirect_to(projects_path)
      end
    end

    context "as a signed in user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should return forbidden" do
        get :new, format: 'js'
        expect(response).not_to be_success
        expect(response.status).to be 403
        expect(response).not_to redirect_to(projects_path)
      end
    end

    context "as a visitor" do
      it "should return unauthorized" do
        get :new, format: 'js'
        expect(response).not_to be_success
        expect(response.status).to be 401
      end
    end
  end

  describe "GET 'edit'" do
    before { @datapath = FactoryGirl.create(:test_datapath) }

    context "as an admin" do
      before { sign_in @admin }

      it "should be successful" do
        get :edit, id: @datapath, format: 'js'
        expect(response).to be_success
        expect(response).to render_template :edit
      end

      it "should return the datapath" do
        get :edit, id: @datapath, format: 'js'
        expect(assigns(:datapath)).to eq @datapath
      end

      it "should not respond html" do
        expect {
          get :edit, id: @datapath, format: 'html'
        }.to raise_error ActionView::MissingTemplate
      end
    end

    context "as a manager" do
      before { sign_in FactoryGirl.create(:manager) }

      it "should return forbidden" do
        get :edit, id: @datapath, format: 'js'
        expect(response).not_to be_success
        expect(response.status).to be 403
        expect(response).not_to redirect_to(projects_path)
      end
    end

    context "as a signed in user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should return forbidden" do
        get :edit, id: @datapath, format: 'js'
        expect(response).not_to be_success
        expect(response.status).to be 403
        expect(response).not_to redirect_to(projects_path)
      end
    end

    context "as a visitor" do
      it "should return unauthorized" do
        get :edit, id: @datapath, format: 'js'
        expect(response).not_to be_success
        expect(response.status).to be 401
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

    context "as a manager" do
      before { sign_in FactoryGirl.create(:manager) }

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

  describe "Patch 'update'" do
    before do
     @datapath = FactoryGirl.create(:test_datapath)
     @new_datapath_attrs = FactoryGirl.attributes_for(:test_datapath)
     Pathname.new(@new_datapath_attrs[:path]).mkpath unless File.exist?(@new_datapath_attrs[:path])
    end

    context "as an admin" do
      before { sign_in @admin }

      context 'with valid parameters' do
        it "should be a success" do
          patch :update, id: @datapath, datapath: @new_datapath_attrs, format: 'js'
          expect(response).to be_success
        end

        it "should update the share link" do
          patch :update, id: @datapath, datapath: @new_datapath_attrs, format: 'js'
          @datapath.reload
          expect(assigns(:datapath)).to eq @datapath
          expect(@datapath.path).to eq @new_datapath_attrs[:path]
        end
      end

      context "with invalid parameters" do
        it "should render the update template" do
          patch :update, id: @datapath, datapath: {path: "my_invalid_path"}, format: 'js'
          expect(response).to be_success
          expect(response).to render_template :update
        end

        it "should not change the datapath's attributes" do
          expect {
            patch :update, id: @datapath, datapath: {path: "my_invalid_path"}, format: 'js'
            @datapath.reload
          }.not_to change(@datapath, :path)
          expect(assigns(:datapath)).to eq @datapath
        end
      end

      it "should not respond html" do
        expect {
          patch :update, id: @datapath, datapath: @new_datapath_attrs, format: 'html'
        }.to raise_error ActionView::MissingTemplate
      end
    end

    context "as a manager" do
      before { sign_in FactoryGirl.create(:manager) }

      it "should return forbidden" do
        patch :update, id: @datapath, datapath: @new_datapath_attrs, format: 'js'
        expect(response).not_to be_success
        expect(response.status).to be 403
        expect(response).not_to redirect_to(projects_path)
      end

      it "should not update the datapath" do
        expect{
          patch :update, id: @datapath, datapath: @new_datapath_attrs, format: 'js'
        }.not_to change(@datapath, :path)
      end
    end

    context "as a signed in user" do
      before { sign_in FactoryGirl.create(:user) }

      it "should return forbidden" do
        patch :update, id: @datapath, datapath: @new_datapath_attrs, format: 'js'
        expect(response).not_to be_success
        expect(response.status).to be 403
        expect(response).not_to redirect_to(projects_path)
      end

      it "should not update the datapath" do
        expect{
          patch :update, id: @datapath, datapath: @new_datapath_attrs, format: 'js'
        }.not_to change(@datapath, :path)
      end
    end

    context "as a visitor" do
      it "should return unauthorized" do
        patch :update, id: @datapath, datapath: @new_datapath_attrs, format: 'js'
        expect(response).not_to be_success
        expect(response.status).to be 401
      end

      it "should not change the share link's attributes" do
        expect{
          patch :update, id: @datapath, datapath: @new_datapath_attrs, format: 'js'
        }.not_to change(@datapath, :path)
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

    context "as a manager" do
      before { sign_in FactoryGirl.create(:manager) }

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
