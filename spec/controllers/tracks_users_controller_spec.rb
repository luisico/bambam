require 'rails_helper'

RSpec.describe TracksUsersController, type: :controller do
  describe "filters" do
    it { is_expected.to use_before_action :authenticate_user! }
  end

  before do
    @user = FactoryGirl.create(:user)
    @track = FactoryGirl.create(:track)
    @tracks_user_attr = {track_id: @track.id, locus: '123'}
  end

  describe "Post 'create'" do
    context "as a user" do
      before { sign_in @user }

      it { is_expected.to permit(:track_id, :locus).for(:create, params: {format: :js}) }

      context "with valid parameters" do
        it "should be a success" do
          post :create, tracks_user: @tracks_user_attr, format: :js
          expect(response).to be_success
          expect(response.header['Content-Type']).to include 'application/json'
        end

        it "should create a new tracks_user" do
          expect{
            post :create, tracks_user: @tracks_user_attr, format: :js
          }.to change(TracksUser, :count).by(1)
        end
      end

      context "failed creation" do
        before { allow_any_instance_of(TracksUser).to receive(:save).and_return(false) }

        it "should raise file system error" do
          post :create, tracks_user: @tracks_user_attr, format: :js
          expect(response.status).to eq 400
          expect(response.header['Content-Type']).to include 'application/json'
          json = JSON.parse(response.body)
          expect(json['status']).to eq 'error'
          expect(json['message']).to eq 'Record not created'
        end

        it "should not create a new track" do
          expect{
            post :create, tracks_user: @tracks_user_attr, format: :js
          }.not_to change(TracksUser, :count)
        end
      end
    end

    context "as a visitor" do
      it "should return unauthorized response" do
        post :create, tracks_user: @tracks_user_attr, format: :js
        expect(response.status).to be 401
      end

      it "should not create a new track" do
        expect{
          post :create, tracks_user: @tracks_user_attr, format: :js
        }.not_to change(Track, :count)
      end
    end
  end

  describe "Patch 'update'" do
    before { @tracks_user = FactoryGirl.create(:tracks_user, track: @track, user: @user) }

    context "as a user" do
      before { sign_in @user }

      context "with valid parameters" do
        it "should be a success" do
          patch :update, id: @tracks_user, tracks_user: {locus: '456'}, format: :js
          expect(response).to be_success
        end

        it "should update attributes'" do
          patch :update, id: @tracks_user, tracks_user: {locus: '456'}, format: :js
          @tracks_user.reload
          expect(@tracks_user.locus).to eq '456'
        end
      end

      context "failed update" do
        before { allow_any_instance_of(TracksUser).to receive(:save).and_return(false) }

        it "should not be a success" do
          patch :update, id: @tracks_user, tracks_user: {locus: '456'}, format: :js
          expect(response.status).to eq 422
        end

        it "should not update attribute" do
          expect {
            patch :update, id: @tracks_user, tracks_user: {locus: '456'}, format: :js
            @track.reload
          }.not_to change(@track, :name)
        end
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        patch :update, id: @tracks_user, tracks_user: {locus: '456'}, format: :js
        expect(response.status).to be 401
      end

      it "should not change the track's attributes" do
        expect{
          patch :update, id: @tracks_user, tracks_user: {locus: '456'}, format: :js
        }.not_to change(@tracks_user, :locus)
      end
    end
  end
end
