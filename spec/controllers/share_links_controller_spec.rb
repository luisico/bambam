require 'spec_helper'

describe ShareLinksController do
  before do
    @admin = FactoryGirl.create(:admin)
    @project = FactoryGirl.create(:project)
    @track = FactoryGirl.create(:test_track, project: @project)
  end

  describe "Post 'create'" do
    before { @share_link_attr = FactoryGirl.attributes_for(:share_link).merge(track_id: @track.id) }

    context "as an admin" do
      before { sign_in @admin }

      context "with valid parameters" do
        it "should be a success" do
          post :create, share_link: @share_link_attr, :format => 'js'
          expect(response).to be_success
        end

        it "should create a new project" do
          expect{
            post :create, share_link: @share_link_attr, :format => 'js'
          }.to change(ShareLink, :count).by(1)
        end
      end

      context "with invalid parameters" do
        it "should not create a new share_link" do
          expect{
            post :create, share_link: @share_link_attr.merge(track_id: ""), :format => 'js'
          }.not_to change(ShareLink, :count)
        end
      end
    end

    # context "as a signed in user" do
    #   before { sign_in FactoryGirl.create(:user) }

    #   it "should redirect to the projects page" do
    #     post :create, share_link: @share_link_attr, :format => 'js'
    #     expect(response).not_to be_success
    #     expect(response).to redirect_to projects_path
    #   end

    #   it "should not create a new project" do
    #     expect {
    #       post :create, share_link: @share_link_attr, :format => 'js'
    #     }.not_to change(ShareLink, :count)
    #   end
    # end

    context "as a visitor" do
      # it "should redirect to the sign in page" do
      #   post :create, share_link: @share_link_attr, :format => 'js'
      #   expect(response).not_to be_success
      #   expect(response).to redirect_to new_user_session_url
      # end

      it "should not create a new project" do
        expect{
          post :create, share_link: @share_link_attr, :format => 'js'
        }.not_to change(ShareLink, :count)
      end
    end
  end

  # describe "Patch 'update'" do
  #   before do
  #    @project = @projects.first
  #    @new_project = FactoryGirl.attributes_for(:project)
  #   end

  #   context "as an admin" do
  #     before { sign_in @admin }

  #     context 'with valid parameters' do
  #       before { @user = FactoryGirl.create(:user) }

  #       it "should redirect to the updated show page" do
  #         patch :update, id: @project, project: @new_project.merge(user_ids: [@user.id])
  #         expect(response).to redirect_to @project
  #       end

  #       it "should update the project" do
  #         patch :update, id: @project, project: @new_project.merge(user_ids: [@user.id])
  #         @project.reload
  #         expect(assigns(:project)).to eq @project
  #         expect(@project.name).to eq @new_project[:name]
  #         expect(@project.users).to include @user
  #       end
  #     end

  #     context "with invalid parameters" do
  #       it "should render the edit template" do
  #         patch :update, id: @project, project: {name: ''}
  #         expect(response).to be_success
  #         expect(response).to render_template :edit
  #       end

  #       it "should not change the project's attributes" do
  #         expect {
  #           patch :update, id: @project, project: {name: ''}
  #           @project.reload
  #         }.not_to change(@project, :name)
  #         expect(assigns(:project)).to eq @project
  #       end
  #     end
  #   end

  #   context "as a signed in user and project member" do
  #     before do
  #       sign_in FactoryGirl.create(:user, projects: [@project])
  #       @track = FactoryGirl.create(:test_track, project: @project)
  #     end

  #     context 'with valid parameters' do
  #       it "should redirect to the updated show page" do
  #         patch :update, id: @project, project: {tracks_attributes: {"0" => {name: 'new_name', id: @track.id}}}
  #         expect(response).to redirect_to @project
  #       end

  #       it "should update the project" do
  #         patch :update, id: @project, project: {tracks_attributes: {"0" => {name: 'new_name', id: @track.id}}}
  #         @track.reload
  #         expect(assigns(:project)).to eq @project
  #         expect(@track.name).to eq('new_name')
  #       end
  #     end

  #     context "with invalid parameters" do
  #       it "should render the edit template" do
  #         patch :update, id: @project, project: {tracks_attributes: {"0" => {name: '', id: @track.id}}}
  #         expect(response).to be_success
  #         expect(response).to render_template :edit
  #       end

  #       it "should not change the track's attributes" do
  #         expect {
  #           patch :update, id: @project, project: {tracks_attributes: {"0" => {name: '', id: @track.id}}}
  #           @track.reload
  #         }.not_to change(@track, :name)
  #         expect(assigns(:project)).to eq @project
  #       end
  #     end
  #   end

  #   context "as a visitor" do
  #     it "should redirect to the sign in page" do
  #       patch :update, id: @project, project: @new_project
  #       expect(response).not_to be_success
  #       expect(response).to redirect_to new_user_session_url
  #     end

  #     it "should not change the project's attributes" do
  #       expect{
  #         patch :update, id: @project, project: @new_project
  #       }.not_to change(@project, :name)
  #     end
  #   end
  # end

  # describe "Delete 'destroy'" do
  #   before { @project = FactoryGirl.create(:project, owner: @admin) }

  #   context "as an admin" do
  #     before { sign_in @admin }

  #     it "should redirect to project#index" do
  #       delete :destroy, id: @project
  #       expect(response).to redirect_to projects_url
  #     end

  #     it "should delete the project" do
  #       expect{
  #         delete :destroy, id: @project
  #       }.to change(Project, :count).by(-1)
  #       expect(assigns(:project)).to eq @project
  #     end
  #   end

  #   context "as a signed in user" do
  #     before { sign_in FactoryGirl.create(:user) }
  #     it "should redirect to the projects page" do
  #       delete :destroy, id: @project
  #       expect(response).not_to be_success
  #       expect(response).to redirect_to projects_path
  #     end

  #     it "should not delete the project" do
  #       expect{
  #         delete :destroy, id: @project
  #       }.not_to change(Project, :count)
  #     end
  #   end

  #   context "as a visitor" do
  #     it "should redirect to the sign in page" do
  #       delete :destroy, id: @project
  #       expect(response).not_to be_success
  #       expect(response).to redirect_to new_user_session_url
  #     end

  #     it "should not delete the project" do
  #       expect{
  #         delete :destroy, id: @project
  #       }.not_to change(Project, :count)
  #     end
  #   end
  # end
end
