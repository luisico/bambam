require 'spec_helper'

describe TracksController do
  describe "GET 'index'" do
    before { @tracks = FactoryGirl.create_list(:track, 3) }

    context "as a signed in user" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

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

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :index
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "GET 'show'" do
    before { @track = FactoryGirl.create(:track) }

    context "as a signed in user" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it "should be successful" do
        get :show, id: @track
        expect(response).to be_success
        expect(response).to render_template :show
      end

      it "should return tracks" do
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

  describe "GET 'new'" do
    context "as a signed in user" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it "should be successful" do
        get :new
        expect(response).to be_success
        expect(response).to render_template :new
      end

      it "should build a new track" do
        get :new
        expect(assigns(:track)).to be_new_record
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
    before { @track = FactoryGirl.create(:track) }

    context "as a signed in user" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it "should be successful" do
        get :edit, id: @track
        expect(response).to be_success
        expect(response).to render_template :edit
      end

      it "should return tracks" do
        get :edit, id: @track
        expect(assigns(:track)).to eq @track
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :edit, id: @track
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "Post 'create'" do
    before { @track_attr = FactoryGirl.attributes_for(:track) }

    context "as a signed in user" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      context "with valid parameters" do
        it "should create a new track" do
          expect{
            post :create, track: @track_attr
          }.to change(Track, :count).by(1)
          expect(assigns(:track)).to eq Track.last
        end

        it "should redirect to the show page" do
          post :create, track: @track_attr
          expect(response).to redirect_to track_path(Track.last)
        end
      end

      context "with invalid parameters" do
        it "should render new template" do
          post :create, track: @track_attr.merge(name: '')
          expect(response).to be_success
          expect(response).to render_template :new
        end

        it "should not create a new track" do
          expect{
            post :create, track: @track_attr.merge(name: '')
          }.not_to change(Track, :count)
          expect(assigns(:track)).to be_new_record
        end

        it "should mark invalid parameters" do
          post :create, track: @track_attr.merge(name: '', path: '')
          expect(assigns(:track)).not_to be_valid
          expect(assigns(:track).errors[:name]).not_to be_blank
          expect(assigns(:track).errors[:path]).not_to be_blank
        end
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        post :create, track: @track_attr
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end

      it "should not create a new track" do
        post :create, track: @track_attr
      end
    end
  end

  describe "Patch 'update'" do
    before { @track = FactoryGirl.create(:track) }

    context "as a signed in user" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      context 'with valid parameters' do
        before { @track_attrs = {name: 'new_name', path: 'new_path'}.with_indifferent_access }

        it "should update the track" do
          patch :update, id: @track, track: @track_attrs
          @track.reload
          expect(assigns(:track)).to eq @track
          expect(@track.attributes.except('id', 'created_at', 'updated_at')).to eq @track_attrs
        end

        it "should redirect to the updated show page" do
          patch :update, id: @track, track: @track_attrs
          expect(response).to redirect_to @track
        end
      end

      context "with invalid parameters" do
        it "should render the edit template" do
          patch :update, id: @track, track: {path: ''}
          expect(response).to be_success
          expect(response).to render_template :edit
        end

        it "should not change the track's attributes" do
          expect {
            patch :update, id: @track, track: {path: ''}
            @track.reload
          }.not_to change(@track, :path)
          expect(assigns(:track)).to eq @track
        end

        it "should mark invalid parameters" do
          patch :update, id: @track, track: {name: '', path: ''}
          expect(assigns(:track)).not_to be_valid
          expect(assigns(:track).errors[:name]).not_to be_blank
          expect(assigns(:track).errors[:path]).not_to be_blank
        end
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        patch :update, id: @track, track: {name: ''}
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end

      it "should not create a new track" do
        patch :update, id: @track, track: {name: ''}
      end
    end
  end

  describe "Delete 'destroy'" do
    before { @track = FactoryGirl.create(:track) }

    context "as a signed in user" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it "should delete the track" do
        expect{
          delete :destroy, id: @track
        }.to change(Track, :count).by(-1)
        expect(assigns(:track)).to eq @track
      end

      it "should redirect to track#index" do
        delete :destroy, id: @track
        expect(response).to redirect_to tracks_url
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        delete :destroy, id: @track
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end
    end
  end
end
