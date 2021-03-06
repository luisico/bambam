require 'rails_helper'

RSpec.describe ShareLinksController do
  describe "filters" do
    it { is_expected.to use_before_action :authenticate_user! }
  end

  before do
    @project = FactoryGirl.create(:project)
    @track = FactoryGirl.create(:track, project: @project)
    @user = FactoryGirl.create(:user, projects: [@project])
  end

  describe "GET 'new'" do
    context "as a signed in user and project member" do
      before { sign_in @user }

      it "should be successful" do
        xhr :get, :new, share_link: {track_id: @track.id}, format: :js
        expect(response).to be_success
        expect(response).to render_template :new
      end

      it "should build a new share link" do
        xhr :get, :new, share_link: {track_id: @track.id}, format: :js
        expect(assigns(:share_link)).to be_new_record
      end

      it "should not respond html" do
        expect {
          get :new, share_link: {track_id: 1}, format: :html
        }.to raise_error ActionView::MissingTemplate
      end
    end

    context "as a visitor" do
      it "should return unauthorized" do
        xhr :get, :new, share_link: {track_id: @track.id}, format: :js
        expect(response).not_to be_success
        expect(response.status).to be 401
      end
    end
  end

  describe "GET 'edit'" do
    before { @share_link = FactoryGirl.create(:share_link, track: @track) }

    context "as a signed in user and project member" do
      before { sign_in @user }

      it "should be successful" do
        xhr :get, :edit, id: @share_link, format: :js
        expect(response).to be_success
        expect(response).to render_template :edit
      end

      it "should return the share link" do
        xhr :get, :edit, id: @share_link, format: :js
        expect(assigns(:share_link)).to eq @share_link
      end

      it "should not respond html" do
        expect {
          xhr :get, :edit, id: @share_link, format: :html
        }.to raise_error ActionView::MissingTemplate
      end
    end

    context "as a visitor" do
      it "should return unauthorized" do
        xhr :get, :edit, id: @share_link, format: :js
        expect(response).not_to be_success
        expect(response.status).to be 401
      end
    end
  end

  describe "Post 'create'" do
    before { @share_link_attr = FactoryGirl.attributes_for(:share_link).merge(track_id: @track.id) }

    context "as a signed in user and project member" do
      before { sign_in @user }

      it { is_expected.to permit(:expires_at, :track_id, :notes).for(:create, params: {format: :js}) }

      context "with valid parameters" do
        it "should be a success" do
          post :create, share_link: @share_link_attr, format: :js
          expect(response).to be_success
        end

        it "should create a new share link" do
          expect{
            post :create, share_link: @share_link_attr, format: :js
          }.to change(ShareLink, :count).by(1)
        end
      end

      context "with invalid parameters" do
        it "should not create a new share link" do
          expect{
            post :create, share_link: @share_link_attr.merge(track_id: ""), format: :js
          }.not_to change(ShareLink, :count)
        end

        it "should not allow custom access_token" do
          expect{
            post :create, share_link: @share_link_attr.merge(access_token: "my_token"), format: :js
          }.to change(ShareLink, :count).by(1)
          expect(assigns(:share_link).access_token).not_to eq "my_token"
        end
      end

      it "should not respond html" do
        expect {
          post :create, share_link: @share_link_attr, format: :html
        }.to raise_error ActionView::MissingTemplate
      end
    end

    context "as a visitor" do
      it "should return unauthorized response" do
        post :create, share_link: @share_link_attr, format: :js
        expect(response).not_to be_success
        expect(response.status).to be 401
      end

      it "should not create a new share link" do
        expect{
          post :create, share_link: @share_link_attr, format: :js
        }.not_to change(ShareLink, :count)
      end
    end
  end

  describe "Patch 'update'" do
    before do
      @share_link = FactoryGirl.create(:share_link, track: @track)
      @new_share_link = FactoryGirl.attributes_for(:share_link)
    end

    context "as a signed in user and project member" do
      before { sign_in @user }

      it { is_expected.to permit(:expires_at, :track_id, :notes).for(:update, params: {id: @share_link, format: :js}) }

      context 'with valid parameters' do
        it "should redirect to the updated show page" do
          patch :update, id: @share_link, share_link: @new_share_link.merge(track_id: [@track.id]), format: :js
          expect(response).to be_success
        end

        it "should update the share link" do
          patch :update, id: @share_link, share_link: @new_share_link.merge(track_id: [@track.id]), format: :js
          @share_link.reload
          expect(assigns(:share_link)).to eq @share_link
          expect(@share_link.expires_at).to eq @new_share_link[:expires_at]
          expect(@share_link.track).to eq @track
        end
      end

      context "with invalid parameters" do
        it "should render the update template" do
          patch :update, id: @share_link, share_link: {expires_at: "#{Date.yesterday}"}, format: :js
          expect(response).to be_success
          expect(response).to render_template :update
        end

        it "should not change the share link's attributes" do
          expect {
            patch :update, id: @share_link, share_link: {expires_at: "#{Date.yesterday}"}, format: :js
            @share_link.reload
          }.not_to change(@share_link, :expires_at)
          expect(assigns(:share_link)).to eq @share_link
        end

        it "should not allow custom access_token" do
          expect{
            patch :update, id: @share_link, share_link: {access_token: "my_token"}, format: :js
            @share_link.reload
          }.not_to change(@share_link, :access_token)
        end
      end

      it "should not respond html" do
        expect {
          patch :update, id: @share_link, share_link: @new_share_link, format: :html
        }.to raise_error ActionView::MissingTemplate
      end
    end

    context "as a visitor" do
      it "should return unauthorized" do
        patch :update, id: @share_link, share_link: @new_share_link.merge(track_id: [@track.id]), format: :js
        expect(response).not_to be_success
        expect(response.status).to be 401
      end

      it "should not change the share link's attributes" do
        expect{
          patch :update, id: @share_link, share_link: @new_share_link.merge(track_id: [@track.id]), format: :js
        }.not_to change(@share_link, :expires_at)
      end
    end
  end

  describe "Delete 'destroy'" do
    before { @share_link = FactoryGirl.create(:share_link, track: @track) }
    context "as a signed in user and project member" do
      before { sign_in @user }

      it "should be a success" do
        delete :destroy, id: @share_link, format: :js
        expect(response).to be_success
      end

      it "should delete the share link" do
        expect{
          delete :destroy, id: @share_link, format: :js
        }.to change(ShareLink, :count).by(-1)
        expect(assigns(:share_link)).to eq @share_link
      end
    end

    context "as a visitor" do
      it "should return unauthorized" do
        delete :destroy, id: @share_link, format: :js
        expect(response).not_to be_success
        expect(response.status).to be 401
      end

      it "should not delete the share link" do
        expect{
          delete :destroy, id: @share_link, format: :js
        }.not_to change(ShareLink, :count)
      end
    end
  end
end
