require 'spec_helper'

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
      @track_attr = FactoryGirl.attributes_for(:track)
      @full_path = File.join @projects_datapath.full_path, @track_attr[:path]
    end

    after { File.unlink @full_path if File.exists? @full_path }

    context "as a signed in user and project member" do
      before { sign_in FactoryGirl.create(:user, projects: [@project]) }

      context "project datapath creation" do
        context "with valid parameters" do
          before do
            cp_track @full_path
            @track_attr.merge!(projects_datapath_id: @projects_datapath.id)
          end

          it "should be a success" do
            post :create, track: @track_attr, format: :json
            expect(response).to be_success
            expect(response.header['Content-Type']).to include 'application/json'
            json = JSON.parse(response.body)
            expect(json['track_id']).to eq Track.last.id
          end

          it "should create a new project's datapath" do
            expect{
              post :create, track: @track_attr, format: :json
            }.to change(Track, :count).by(1)
          end
        end
      end

      context "with invalid parameters" do
        context "invalid datapath" do
          it "should raise not found error" do
            post :create, track: @track_attr, format: :json
            expect(response.status).to eq 400
            expect(response.header['Content-Type']).to include 'application/json'
            json = JSON.parse(response.body)
            expect(json['status']).to eq 'error'
            expect(json['message']).to eq 'must exist in filesystem'
          end

          it "should not create a new project's datapath" do
            expect{
              post :create, track: @track_attr, format: :json
            }.not_to change(Track, :count)
          end
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

      it "should not create a new project's datapath" do
        expect{
          post :create, track: @track_attr, format: :json
        }.not_to change(ProjectsDatapath, :count)
      end
    end
  end
end
