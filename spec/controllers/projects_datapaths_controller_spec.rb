require 'spec_helper'

def create_projects_datapath
  @datapath = FactoryGirl.create(:datapath)
  @project = FactoryGirl.create(:project)
  @projects_datapath_attr = FactoryGirl.attributes_for(:projects_datapath)
  @projects_datapath_attr.merge!(datapath_id: @datapath.id, project_id: @project.id)
end

describe ProjectsDatapathsController do
  before { @manager = FactoryGirl.create(:manager) }

  describe "Post 'create'" do
    before { create_projects_datapath }

    context "as a signed in manager and project owner" do
      before { sign_in @manager }

      context "project datapath creation" do
        context "with valid parameters" do
          it "should be a success" do
            post :create, projects_datapath: @projects_datapath_attr, format: :json
            expect(response).to be_success
            expect(response.header['Content-Type']).to include 'application/json'
            json = JSON.parse(response.body)
            expect(json['status']).to eq 'success'
            expect(json['message']).to eq 'OK'
          end

          it "should create a new project's datapath" do
            expect{
              post :create, projects_datapath: @projects_datapath_attr, format: :json
            }.to change(ProjectsDatapath, :count).by(1)
          end
        end
      end

      context "with invalid parameters" do
        context "invalid datapath" do
          before { @datapath.destroy }

          it "should raise not found error" do
            post :create, projects_datapath: @projects_datapath_attr, format: :json
            expect(response.status).to eq 400
            expect(response.header['Content-Type']).to include 'application/json'
            json = JSON.parse(response.body)
            expect(json['status']).to eq 'error'
            expect(json['message']).to eq 'datapath must exist'
          end

          it "should not create a new project's datapath" do
            expect{
              post :create, projects_datapath: @projects_datapath_attr, format: :json
            }.not_to change(ProjectsDatapath, :count)
          end
        end
      end
    end

    context "as a signed in user" do
      before { sign_in FactoryGirl.create(:user) }

      # TODO: format should be :json
      it "should return forbidden response" do
        post :create, projects_datapath: @projects_datapath_attr, format: :js
        expect(response).not_to be_success
        expect(response.status).to be 403
      end

      # TODO: format should be :json
      it "should not create a new projects datapath" do
        expect {
          post :create, projects_datapath: @projects_datapath_attr, format: :js
        }.not_to change(ProjectsDatapath, :count)
      end
    end

    context "as a visitor" do
      it "should return unauthorized response" do
        post :create, projects_datapath: @projects_datapath_attr, format: :json
        expect(response.status).to be 401
        expect(response.header['Content-Type']).to include 'application/json'
        json = JSON.parse(response.body)
        expect(json['error']).to eq I18n.t('devise.failure.unauthenticated')
      end

      it "should not create a new project's datapath" do
        expect{
          post :create, projects_datapath: @projects_datapath_attr, format: :json
        }.not_to change(ProjectsDatapath, :count)
      end
    end
  end

  describe "Delete 'destroy'" do
    before do
      create_projects_datapath
      @projects_datapath = FactoryGirl.create(:projects_datapath, @projects_datapath_attr)
      @project.datapaths << @datapath
    end

    context "as a signed in manager and project owner" do
      before { sign_in @manager }

      context "with valid parameters" do
        it "should be a success" do
          delete :destroy, id: @projects_datapath.id, format: :json
          expect(response).to be_success
          expect(response.header['Content-Type']).to include 'application/json'
          json = JSON.parse(response.body)
          expect(json['status']).to eq 'success'
          expect(json['message']).to eq 'OK'
        end

        it "should destroy the project's datapath" do
          expect{
            delete :destroy, id: @projects_datapath.id, format: :json
          }.to change(ProjectsDatapath, :count).by(-1)
        end
      end

      context "with invalid parameters" do
        before { @datapath.destroy }

        context "non-existance projects datapath" do
          it "should raise record not found error" do
            delete :destroy, id: @projects_datapath.id, format: :json
            expect(response.status).to eq 400
            expect(response.header['Content-Type']).to include 'application/json'
            json = JSON.parse(response.body)
            expect(json['status']).to eq 'error'
            expect(json['message']).to eq 'file system error'
          end

          it "should not destroy the project's datapath" do
            expect{
              delete :destroy, id: @project.id, projects_datapath: @projects_datapath_attr, format: :json
            }.not_to change(ProjectsDatapath, :count)
          end
        end
      end
    end

    context "as a signed in user" do
      before { sign_in FactoryGirl.create(:user) }

      # TODO: format should be :json
      it "should return forbidden reponse" do
        delete :destroy, id: @projects_datapath.id, format: :js
        expect(response).not_to be_success
        expect(response.status).to be 403
      end

      # TODO: format should be :json
      it "should not delete the projects datapath" do
        expect {
          delete :destroy, id: @projects_datapath.id, format: :js
        }.not_to change(ProjectsDatapath, :count)
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        delete :destroy, id: @projects_datapath.id, format: :json
        expect(response).not_to be_success
        expect(response.status).to be 401
        expect(response.header['Content-Type']).to include 'application/json'
        json = JSON.parse(response.body)
        expect(json['error']).to eq I18n.t('devise.failure.unauthenticated')
      end

      it "should not delete the projects datapath" do
        expect{
          delete :destroy, id: @projects_datapath.id, format: :json
        }.not_to change(ProjectsDatapath, :count)
      end
    end
  end

  describe "GET 'browser'" do
    context "as a signed in user" do
      before do
        user = FactoryGirl.create(:user)
        sign_in user
        @project = FactoryGirl.create(:project)
      end

      context "responds to json" do
        it "should be successful" do
          get :browser, id: @project, format: :json
          expect(response).to be_success
          expect(response.header['Content-Type']).to include 'application/json'
        end

        it "should use the project owners datapaths" do
          controller.stub(:tree).and_return([{title: 'path', key: 1}])
          expect(controller).to receive(:generate_tree).with(@project.owner.datapaths).and_return([{}])
          get :browser, id: @project, format: :json
        end

        it "should render json from the generate_tree method" do
          json = [{title: nil, key: nil, selected: nil}]
          expect(controller).to receive(:generate_tree).and_return(json)
          get :browser, id: @project, format: :json
          expect(response.body).to eq "[{\"title\":null,\"key\":null,\"selected\":null}]"
        end
      end

      it "should not respond to html" do
        expect {
          get :browser, id: @project, format: :html
        }.to raise_error ActionController::UnknownFormat
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :browser, id: @project, format: :json
        expect(response.status).to eq 401
        expect(response.header['Content-Type']).to include 'application/json'
        json = JSON.parse(response.body)
        expect(json['error']).to eq I18n.t('devise.failure.unauthenticated')
      end
    end
  end

  describe "#generate_tree" do
    before do
      @datapath1 = FactoryGirl.create(:datapath)
      controller.instance_variable_set(:@project, FactoryGirl.create(:project))
      controller.stub(:cannot?).and_return(false)
    end

    it "creates nodes for all files and directories found recursively" do
      datapath2 = FactoryGirl.create(:datapath)
      datapath1_paths =  %w(/dir1/ /dir2/dir3/ /dir2/dir4/ /dir5/dir6/).collect do |dir|
        @datapath1.path + dir
      end
      datapath2_paths = [datapath2.path + "/dir6/"]

      expect(Dir).to receive(:glob).and_return( datapath1_paths, datapath2_paths)

      expect(controller.send(:generate_tree, [@datapath1, datapath2])).to eq [
        {:title=>@datapath1.path, :key=>@datapath1.id, :folder=>true, :children=>[
          {:title=>"dir1", :folder=>true},
          {:title=>"dir2", :folder=>true, :children=>[
            {:title=>"dir3", :folder=>true},
            {:title=>"dir4", :folder=>true}]},
            {:title=>"dir5", :folder=>true, :children=>[
              {:title=>"dir6", :folder=>true}
            ]}
          ]},
        {:title=>datapath2.path, :key=>datapath2.id, :folder=>true, :children=>[
          {:title=>"dir6", :folder=>true}]
        }]
    end

    it "marks a path as empty when no tracks are found" do
      expect(Dir).to receive(:glob).and_return [@datapath1.path]

      expect(controller.send(:generate_tree, [@datapath1])).to eq [
        {title: @datapath1.path, key: @datapath1.id, folder: true}
      ]
    end

    it "marks project's datapaths as selected and expanded" do
      datapath2 = FactoryGirl.create(:datapath)
      project = FactoryGirl.create(:project, datapaths: [datapath2])
      projects_datapaths = %w(dir1 dir1/subdir2/subdir3).collect do |sub_dir|
        FactoryGirl.create(:projects_datapath,
          datapath: @datapath1,
          project: project,
          sub_directory: sub_dir)
      end
      track = FactoryGirl.create(:track, projects_datapath: projects_datapaths.last)
      project.reload

      controller.instance_variable_set(:@project, project)

      expect(controller.send(:generate_tree, [@datapath1, datapath2])).to eq [
        {:title=>@datapath1.path, :key=>@datapath1.id, :folder=>true, :expanded=>true,
          :children=>[
          {:title=>"dir1", :selected=>true, :projects_datapath_id=>projects_datapaths.first.id.to_s, :folder=>true,
            :children=>[
            {:title=>"subdir2", :folder=>true, :expanded=>true,
              :children=>[
              {:title=>"subdir3", :selected=>true, :projects_datapath_id=>projects_datapaths.last.id.to_s, :folder=>true,
                :children=>[
                {:title=>"tracks", :folder=>true}]}]}], :expanded=>true}]},
        {:title=>datapath2.path, :key=>datapath2.id, :selected=>true, :projects_datapath_id=>project.projects_datapaths.first.id, :folder=>true}
      ]
    end
  end

  describe "#add_node_to_tree" do
    context "top level nodes" do
      before do
        controller.stub(:cannot?).and_return(false)
        @datapath = FactoryGirl.create(:datapath)
      end

      it "returns the node with datapath id as key" do
        controller.instance_variable_set(:@project, @project)
        expect(controller.send(:add_node_to_tree, [], @datapath.path, false, @datapath.id)).to eq(
          {title: @datapath.path, key: @datapath.id, folder: true}
        )
      end

      it "does not add an existing node" do
        tree = []
        node = controller.send(:add_node_to_tree, tree, '/dir1')
        controller.send(:add_node_to_tree, tree, '/dir1')
        expect(tree).to eq [node]
      end

      it "sets the tree as parent" do
        tree = []
        node = controller.send(:add_node_to_tree, tree, '/dir1')
        expect(tree).to eq [node]
      end

      it "does not set the folder attribute to the parent" do
        # TODO: repeted from above
        tree = []
        node = controller.send(:add_node_to_tree, tree, '/dir1')
        expect(tree).to eq [node]
      end

      context "node" do
        it "has an expanded attribute if requested" do
          expect(controller.send(:add_node_to_tree, [], '/dir1', true)).to have_key(:expanded)
        end

        it "does not have an expanded attribute if not requested" do
          expect(controller.send(:add_node_to_tree, [], '/dir1')).not_to have_key(:expanded)
          expect(controller.send(:add_node_to_tree, [], '/dir1', false)).not_to have_key(:expanded)
        end

        it "has a title attribute" do
          expect(controller.send(:add_node_to_tree, [], '/dir1')[:title]).to eq '/dir1'
        end

        it "has a projects_datapath_id attribute if requested" do
          expect(controller.send(:add_node_to_tree, [], '/dir1', true, 1, true, 2)).
          to eq({:title=>"/dir1", :key=>1, :expanded=>true, :selected=>true, :projects_datapath_id=>2, :folder=>true})
        end

        it "does not no have a projects_datapath_id attribute if it's not selected" do
          expect(controller.send(:add_node_to_tree, [], '/dir1', true, 1, false, 2)).
          to eq({:title=>"/dir1", :key=>1, :expanded=>true, :folder=>true})
        end
      end
    end

    context "regular nodes" do
      before do
        tree = [{title: '/dir1', key: 1}]
        @parent = tree.first
        controller.instance_variable_set(:@key, 1)
        controller.stub(:cannot?).and_return(false)
      end

      it "returns the node" do
        expect(controller.send(:add_node_to_tree, @parent, '/dir2')).to eq({title: '/dir2', folder: true})
      end

      it "does not add an existing node" do
        node = controller.send(:add_node_to_tree, @parent, '/dir2')
        controller.send(:add_node_to_tree, @parent, '/dir2')
        expect(@parent[:children]).to eq [node]
      end

      it "sets the children attribute as parent" do
        expect(@parent[:children]).to be_nil
        node = controller.send(:add_node_to_tree, @parent, '/dir2')
        expect(@parent[:children]).to eq [node]
      end

      context "node" do
        it "has an expanded attribute if requested" do
          expect(controller.send(:add_node_to_tree, @parent, '/dir2', true)).to have_key(:expanded)
        end

        it "does not have an expanded attribute if not requested" do
          expect(controller.send(:add_node_to_tree, @parent, '/dir2')).not_to have_key(:expanded)
          expect(controller.send(:add_node_to_tree, @parent, '/dir2', false)).not_to have_key(:expanded)
        end

        it "has a title attribute" do
          expect(controller.send(:add_node_to_tree, @parent, '/dir2')[:title]).to eq '/dir2'
        end

        it "has a projects_datapath_id attribute if requested" do
          expect(controller.send(:add_node_to_tree, @parent, '/dir2', false, nil, true, 1)).
          to eq({title: '/dir2', :selected=>true, :projects_datapath_id=>1, :folder=>true})
        end

        it "does not no have a projects_datapath_id attribute if it's not selected" do
          expect(controller.send(:add_node_to_tree, @parent, '/dir2', false, nil, false, 1)).
          to eq({title: '/dir2', :folder=>true})
        end
      end
    end

    context "regular users" do
      before { controller.stub(:cannot?).and_return(true) }

      context "top level nodes" do
        it "hides the node checkbox" do
          controller.instance_variable_set(:@project, FactoryGirl.create(:project))
          expect(controller.send(:add_node_to_tree, [], '/dir1')).
          to eq({:title=>"/dir1", :hideCheckbox=>true, :folder=>true})
        end
      end

      context "regular nodes" do
        it "hides the node checkbox" do
          tree = [{title: '/dir1', key: 1}]
          parent = tree.first
          controller.instance_variable_set(:@key, 1)

          expect(controller.send(:add_node_to_tree, parent, '/dir2')).
          to eq({:title=>"/dir2", :hideCheckbox=>true, :folder=>true})
        end
      end
    end
  end
end
