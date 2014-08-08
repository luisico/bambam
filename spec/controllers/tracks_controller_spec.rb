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

  describe "Patch 'update'" do
    before { @track = FactoryGirl.create(:test_track) }

    context "as a signed in user" do
      before { sign_in FactoryGirl.create(:user) }

      context 'with valid parameters' do
        before do
          @new_track = FactoryGirl.attributes_for(:test_track)
          cp_track @new_track[:path]
        end

        it "should redirect to the updated show page" do
          patch :update, id: @track, track: @new_track[:path]
          json = JSON.parse(response.body)
          expect(json['track']['path']).to eq(@new_track[:path])
          expect(response).to be_success
        end

        it "should update the track" do
          patch :update, id: @track, track: @new_track
          @track.reload
          expect(@track.attributes.except('id', 'created_at', 'updated_at', 'project_id')).to eq @new_track.stringify_keys
        end
      end

      context "with invalid parameters" do
        it "should render the edit template" do
          patch :update, id: @track, track: {name: ''}
          expect(response).to be_success
          expect(response).to render_template :edit
        end

        it "should not change the track's attributes" do
          expect {
            patch :update, id: @track, track: {name: ''}
            @track.reload
          }.not_to change(@track, :name)
          expect(assigns(:track)).to eq @track
        end
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        patch :update, id: @track, track: {name: ''}
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end

      it "should not change the track's attributes" do
        expect{
          patch :update, id: @track, track: {name: ''}
        }.not_to change(@track, :name)
      end
    end
  end
end
