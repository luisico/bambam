require 'spec_helper'

describe TracksController do
  before { @admin = FactoryGirl.create(:admin) }

  describe "GET 'index'" do
    before { @tracks = FactoryGirl.create_list(:test_track, 3) }

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
      @track = FactoryGirl.create(:test_track, project: @project)
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

  describe "Patch 'share'" do
    before do
      @project = FactoryGirl.create(:project)
      @track = FactoryGirl.create(:test_track, project: @project)
    end

    context "as a user and project member" do
      before do
        sign_in user = FactoryGirl.create(:user)
        @project.users << user
      end

      context "with valid parameters" do
        it "should update show page" do
          patch :share, id: @track, format: 'js'
          expect(response).to be_success
          expect(assigns(:track)).to eq @track
        end

        it "should create new, associated ShareLink record" do
          expect{
            patch :share, id: @track, format: 'js'
          }.to change(ShareLink, :count).by(1)
          expect(ShareLink.last.track).to eq @track
        end
      end
    end

    context "as a visitor" do
      it "should not be a success" do
        patch :share, id: @track, format: 'js'
        expect(response).not_to be_success
      end

      it "should not create a new ShareLink record" do
        expect{
          patch :share, id: @track, format: 'js'
        }.not_to change(ShareLink, :count)
      end
    end
  end
end
