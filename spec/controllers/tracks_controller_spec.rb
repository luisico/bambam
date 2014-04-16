require 'spec_helper'

def build_track
  FactoryGirl.attributes_for(:track)
end

describe TracksController do
  describe "GET 'index'" do
    before do
      @tracks = FactoryGirl.create_list(:track, 3)
    end

    ['admin', 'inviter', 'user'].each do |user_type|
      context "as a signed in #{user_type}" do
        before do
          @user_type = FactoryGirl.create(user_type)
          sign_in @user_type
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
      @track = FactoryGirl.create(:track)
    end

    ['admin', 'inviter', 'user'].each do |user_type|
      context "as a signed in #{user_type}" do
        before do
          @user_type = FactoryGirl.create(user_type)
          sign_in @user_type
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
    ['admin', 'inviter', 'user'].each do |user_type|
      context "as a signed in #{user_type}" do
        before do
          @user_type = FactoryGirl.create(user_type)
          sign_in @user_type
        end

        it "should be successful" do
          get :new
          expect(response).to be_success
          expect(response).to render_template :new
        end
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
    before do
      @track = FactoryGirl.create(:track)
    end

    ['admin', 'inviter', 'user'].each do |user_type|
      context "as a signed in #{user_type}" do
        before do
          @user_type = FactoryGirl.create(user_type)
          sign_in @user_type
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
    ['admin', 'inviter', 'user'].each do |user_type|
      context "as a signed in #{user_type}" do
        before do
          @user_type = FactoryGirl.create(user_type)
          sign_in @user_type
        end

        it "should redirect to show page with a notice on successful save" do
          expect{
            post :create, track: build_track
          }.to change(Track, :count).by(1)
          expect(response).to redirect_to track_path(assigns[:track])
          expect(flash[:notice]).not_to be_nil
        end

        ['name', 'path'].each do |field|
          it "should re-render new template with invalid #{field}" do
            expect{
              post :create, track: build_track.merge(field => '')
            }.to_not change(Track, :count)
            expect(response).to render_template :new
            expect(flash[:notice]).to be_nil
          end
        end
      end
    end
  end

  describe "Patch 'update'" do
    ['admin', 'inviter', 'user'].each do |user_type|
      context "as a signed in #{user_type}" do
        before do
          @user_type = FactoryGirl.create(user_type)
          sign_in @user_type
          @track = FactoryGirl.create(:track)
        end

        context 'valid attributes' do
          it 'located the requested @track' do
            patch :update, id: @track, track: @track.attributes
            expect(assigns(:track)).to eq(@track)
          end

          ['name', 'path'].each do |field|
            it "changes @track's #{field} attribute" do
              patch :update, id: @track, track: @track.attributes.merge(field => 'change')
              @track.reload
              if field == 'name'
                expect(@track.name).to eq('change')
                expect(@track.path).to eq(@track.path)
              else
                expect(@track.name).to eq(@track.name)
                expect(@track.path).to eq('change')
              end
            end
          end

          it "redirects to the updated track" do
            patch :update, id: @track, track: @track.attributes
            expect(response).to redirect_to @track
          end
        end

        context "with invalid attributes" do
          ['name', 'path'].each do |field|
            it "doesn't change the track's #{field} attribute and renders edit template" do
              if field == 'name'
                track_attributes = @track.attributes.merge(name: 'change', path: '' )
              else
                track_attributes = @track.attributes.merge(name: '', path: 'change' )
              end
              patch :update, id: @track, track: track_attributes
              @track.reload
              if field == 'name'
                expect(@track.name).to_not eq('change')
                expect(@track.path).to eq(@track.path)
              else
                expect(@track.path).to_not eq('change')
                expect(@track.name).to eq(@track.name)
              end
              expect(response).to render_template :edit
            end
          end
        end
      end
    end
  end

  describe "Delete 'destroy'" do
    ['admin', 'inviter', 'user'].each do |user_type|
      context "as a signed in #{user_type}" do
        before do
          @user_type = FactoryGirl.create(user_type)
          sign_in @user_type
          @track = FactoryGirl.create(:track)
        end

        it "deletes the track" do
          expect{
            delete :destroy, id: @track
          }.to change(Track, :count).by(-1)
        end

        it "redirects to track#index" do
          delete :destroy, id: @track
          expect(response).to redirect_to tracks_url
        end
      end
    end
  end
end
