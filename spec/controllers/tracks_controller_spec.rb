require 'spec_helper'
# TODO fix authorization on this controller
describe TracksController do
  before { @admin = FactoryGirl.create(:admin) }

  describe "GET 'index'" do
    before { @tracks = FactoryGirl.create_list(:track, 3) }

    context "as an admin" do
      before { sign_in @admin }

      it "should be successful" do
        get :index
        expect(response).to be_success
        expect(response).to render_template :index
      end

      it "should return all tracks" do
        get :index
        expect(assigns(:tracks)).to eq @tracks
      end
    end

    context "as a signed in user with projects" do
      before do
        user = FactoryGirl.create(:user)
        @tracks.each { |track| track.project.users << user }
        sign_in user
      end

      it "should be successful" do
        get :index
        expect(response).to be_success
        expect(response).to render_template :index
      end

      it "should return users tracks" do
        get :index
        expect(assigns(:tracks)).to eq @tracks
      end
    end

    context "as a signed in user without projects" do
      before { sign_in FactoryGirl.create(:user) }

      it "should be successful" do
        get :index
        expect(response).to be_success
        expect(response).to render_template :index
      end

      it "should return users tracks" do
        get :index
        expect(assigns(:tracks)).to eq []
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
    before do
      @project = FactoryGirl.create(:project)
      @track = FactoryGirl.create(:track, project: @project)
    end

    context "as an admin" do
      before { sign_in @admin }

      it "should be successful" do
        get :show, id: @track
        expect(response).to be_success
        expect(response).to render_template :show
      end

      it "should return the track" do
        get :show, id: @track
        expect(assigns(:track)).to eq @track
      end
    end

    context "as a signed in user with a project" do
      before do
        user = FactoryGirl.create(:user)
        @project.users << user
        sign_in user
      end

      it "should be successful" do
        get :show, id: @track
        expect(response).to be_success
        expect(response).to render_template :show
      end

      it "should return the track" do
        get :show, id: @track
        expect(assigns(:track)).to eq @track
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :show, id: @track
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "Post 'create'" do
    before do
      @project = FactoryGirl.create(:project)
      @projects_datapath = FactoryGirl.create(:projects_datapath, project: @project)
      @track_attr = FactoryGirl.attributes_for(:track).merge!(projects_datapath_id: @projects_datapath.id)
      @full_path = File.join @projects_datapath.full_path, @track_attr[:path]
      cp_track @full_path
    end

    after { File.unlink @full_path if File.exists? @full_path }

    context "as a signed in user and project member" do
      before { sign_in FactoryGirl.create(:user, projects: [@project]) }

      context "with valid parameters" do
        it "should be a success" do
          controller.stub_chain(:view_context, :link_to_igv).and_return('igv_url')
          post :create, track: @track_attr, format: :json
          expect(response).to be_success
          expect(response.header['Content-Type']).to include 'application/json'
          json = JSON.parse(response.body)
          new_track = Track.last
          expect(json['track']).to eq ({"id" => new_track.id, "name" => new_track.name, "igv" => 'igv_url'})
        end

        it "should create a new track" do
          expect{
            post :create, track: @track_attr, format: :json
          }.to change(Track, :count).by(1)
        end
      end

      context "with invalid parameters" do
        it "should raise not found error" do
          post :create, track: @track_attr.except(:projects_datapath_id), format: :json
          expect(response.status).to eq 400
          expect(response.header['Content-Type']).to include 'application/json'
          json = JSON.parse(response.body)
          expect(json['status']).to eq 'error'
          expect(json['message']).to eq 'must exist in filesystem'
        end

        it "should not create a new track" do
          expect{
            post :create, track: @track_attr.except(:projects_datapath_id), format: :json
          }.not_to change(Track, :count)
        end
      end
    end

    context "as a visitor" do
      it "should return unauthorized response" do
        post :create, track: @track_attr, format: :json
        expect(response.status).to be 401
        expect(response.header['Content-Type']).to include 'application/json'
        json = JSON.parse(response.body)
        expect(json['error']).to eq I18n.t('devise.failure.unauthenticated')
      end

      it "should not create a new track" do
        expect{
          post :create, track: @track_attr, format: :json
        }.not_to change(Track, :count)
      end
    end
  end

  describe "Delete 'destroy'" do
    context "as a signed in user and track owner" do
      before do
        user = FactoryGirl.create(:user)
        @track = FactoryGirl.create(:track, owner: user)
        sign_in user
      end

      context "with valid parameters" do
        it "should be a success" do
          delete :destroy, id: @track, format: :js
          expect(response).to be_success
          expect(response.header['Content-Type']).to include 'application/json'
          json = JSON.parse(response.body)
          expect(json['status']).to eq 'success'
          expect(json['message']).to eq 'OK'
        end

        it "should destroy the track" do
          expect{
            delete :destroy, id: @track, format: :js
          }.to change(Track, :count).by(-1)
        end
      end

      context "with invalid parameters" do
        context "non-existance track" do
          it "should raise record not found error" do
            delete :destroy, id: 9999, format: :js
            expect(response.status).to eq 403
            json = JSON.parse(response.body)
            expect(json['status']).to eq 'error'
            expect(json['message']).to eq "You don't have permission to destroy "
          end

          it "should not destroy the track" do
            expect{
              delete :destroy, id: 9999, format: :js
            }.not_to change(Track, :count)
          end
        end
      end
    end

    context "as a signed in user" do
      before do
        @track = FactoryGirl.create(:track)
        sign_in FactoryGirl.create(:user)
      end

      it "should return forbidden reponse" do
        delete :destroy, id: @track.id, format: :js
        expect(response).not_to be_success
        expect(response.status).to be 403
      end

      it "should not delete the track" do
        expect {
          delete :destroy, id: @track.id, format: :js
        }.not_to change(Track, :count)
      end
    end

    context "as a visitor" do
      before { @track = FactoryGirl.create(:track) }

      it "should redirect to the sign in page" do
        delete :destroy, id: @track.id, format: :json
        expect(response).not_to be_success
        expect(response.status).to be 401
        expect(response.header['Content-Type']).to include 'application/json'
        json = JSON.parse(response.body)
        expect(json['error']).to eq I18n.t('devise.failure.unauthenticated')
      end

      it "should not delete the track" do
        expect{
          delete :destroy, id: @track.id, format: :json
        }.not_to change(Track, :count)
      end
    end
  end
end
