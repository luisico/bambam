require 'rails_helper'

# TODO fix authorization on this controller

RSpec.describe TracksController do
  describe "filters" do
    it { is_expected.to use_before_action :authenticate_user! }
  end

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

    after { File.unlink @full_path if File.exist? @full_path }

    context "as a signed in user and project member" do
      before { sign_in FactoryGirl.create(:user, projects: [@project]) }

      context "with valid parameters" do
        it "should be a success" do
          allow(controller).to receive_message_chain(:view_context, :link_to_igv).and_return('igv_url')
          post :create, track: @track_attr, format: :json
          expect(response).to be_success
          expect(response.header['Content-Type']).to include 'application/json'
          json = JSON.parse(response.body)
          new_track = Track.last
          expect(json['track']).to eq ({"id" => new_track.id, "name" => new_track.name, "genome" => new_track.genome, "igv" => 'igv_url'})
        end

        it "should create a new track" do
          expect{
            post :create, track: @track_attr, format: :json
          }.to change(Track, :count).by(1)
        end
      end

      context "failed creation" do
        before do
          allow_any_instance_of(Track).to receive(:save).and_return(false)
          allow_any_instance_of(Track).to receive_message_chain(:errors, :full_messages).and_return(["my", "error"])
        end


        it "should raise file system error" do
          post :create, track: @track_attr, format: :json
          expect(response.status).to eq 400
          expect(response.header['Content-Type']).to include 'application/json'
          json = JSON.parse(response.body)
          expect(json['status']).to eq 'error'
          expect(json['message']).to eq 'my; error'
        end

        it "should not create a new track" do
          expect{
            post :create, track: @track_attr, format: :json
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

  describe "Patch 'update'" do
    before do
      @track = FactoryGirl.create(:track)
      @new_track_attrs = {name: "new_name", genome: "new_genome"}
    end

    context "as an admin" do
      before { sign_in @admin }

      context "update the track" do
        context "with valid parameters" do
          context "name and genome" do
            it "should be a success" do
              patch :update, id: @track, track: @new_track_attrs, format: :json
              expect(response).to be_success
            end

            it "should update attributes'" do
              patch :update, id: @track, track: @new_track_attrs, format: :json
              @track.reload
              expect(@track.name).to eq @new_track_attrs[:name]
              expect(@track.genome).to eq @new_track_attrs[:genome]
            end
          end

          context "projects_datapath_id" do
            before do
              items = @track.projects_datapath.path.split(File::SEPARATOR)
              @projects_datapath = FactoryGirl.create(:projects_datapath, datapath: @track.datapath, path: File.join(items[0...-1]), project: @track.project)
              @path = File.join(items[-1], @track.path)
            end

            it "should be a success" do
              patch :update, id: @track, track: {projects_datapath_id: @projects_datapath.id, path: @path}, format: :json
              expect(response).to be_success
            end

            it "should update the track's projects_datapath'" do
              expect {
                patch :update, id: @track, track: {projects_datapath_id: @projects_datapath.id, path: @path}, format: :json
                @track.reload
              }.to change(@track, :projects_datapath).to @projects_datapath
              expect(@track.path).to eq @path
            end
          end
        end

        context "with invalid parameters" do
          context "name" do
            it "should not be a success" do
              patch :update, id: @track, track: {name: ""}, format: :json
              expect(response.status).to eq 422
            end

            it "should not update attribute" do
              expect {
                patch :update, id: @track, track: {name: ""}, format: :json
                @track.reload
              }.not_to change(@track, :name)
            end
          end

          context "projects_datapath_id" do
            it "should response with unprocessable entity" do
              patch :update, id: @track, track: {projects_datapath_id: 9999 }, format: :json
              expect(response.status).to eq 403
              expect(response.header['Content-Type']).to include 'application/json'
              json = JSON.parse(response.body)
              expect(json["message"]).to include "You don't have permission"
            end

            it "should not change the track's projects datapath" do
              expect {
                patch :update, id: @track, track: {projects_datapath_id: 9999 }, format: :json
                @track.reload
              }.not_to change(@track, :projects_datapath)
            end
          end
        end
      end
    end

    context "as a signed in user" do
      before { sign_in FactoryGirl.create(:user) }

      context 'with valid parameters' do
        it "should not be a success" do
          patch :update, id: @track, track: @new_track_attrs, format: :js
          expect(response).not_to be_success
        end

        it "should not change the track's attributes" do
          expect {
            patch :update, id: @track, track: @new_track_attrs, format: :js
            @track.reload
          }.not_to change(@track, :name)
        end
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        patch :update, id: @track, track: @new_track_attrs
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end

      it "should not change the track's attributes" do
        expect{
          patch :update, id: @track, track: @new_track_attrs
        }.not_to change(@track, :name)
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

      context "format json" do
        context "successful deletion" do
          it "should be a success" do
            delete :destroy, id: @track, format: :json
            expect(response).to be_success
            expect(response.header['Content-Type']).to include 'application/json'
            json = JSON.parse(response.body)
            expect(json['status']).to eq 'success'
            expect(json['message']).to eq 'OK'
          end

          it "should destroy the track" do
            expect{
              delete :destroy, id: @track, format: :json
            }.to change(Track, :count).by(-1)
          end
        end

        context "failed deletion" do
          before do
            allow_any_instance_of(Track).to receive(:destroy).and_return(false)
            allow_any_instance_of(Track).to receive_message_chain(:errors, :full_messages).and_return(["my", "error"])
          end

          it "should raise file system error" do
            delete :destroy, id: @track, format: :json
            expect(response.status).to eq 400
            json = JSON.parse(response.body)
            expect(json['status']).to eq 'error'
            expect(json['message']).to eq "my; error"
          end

          it "should not destroy the track" do
            expect{
              delete :destroy, id: @track, format: :json
            }.not_to change(Track, :count)
          end
        end
      end

      context "format html" do
        context "successful deletion" do
          it "should be a success" do
            delete :destroy, id: @track
            expect(response).to redirect_to project_path(@track.project)
          end

          it "should destroy the track" do
            expect{
              delete :destroy, id: @track
            }.to change(Track, :count).by(-1)
          end
        end

        context "failed deletion" do
          before do
            allow_any_instance_of(Track).to receive(:destroy).and_return(false)
          end

          it "should rediret to the projects page" do
            delete :destroy, id: @track
            expect(response).to redirect_to projects_path
          end

          it "should not destroy the track" do
            expect{
              delete :destroy, id: @track
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
        delete :destroy, id: @track.id
        expect(response).not_to be_success
        expect(response.status).to be 302
      end

      it "should not delete the track" do
        expect {
          delete :destroy, id: @track.id
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
