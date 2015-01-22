require 'spec_helper'

def create_projects_datapath
  @datapath = FactoryGirl.create(:datapath)
  @project = FactoryGirl.create(:project)
  @projects_datapath = FactoryGirl.attributes_for(:projects_datapath)
  @projects_datapath.merge!(datapath_id: @datapath.id, project_id: @project.id)
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
            post :create, projects_datapath: @projects_datapath, format: 'js'
            expect(response).to be_success
          end

          it "should create a new project's datapath" do
            expect{
              post :create, projects_datapath: @projects_datapath, format: 'js'
            }.to change(ProjectsDatapath, :count).by(1)
          end
        end
      end

      context "with invalid parameters" do
        it "should not create a new project's datapath" do
          count = ProjectsDatapath.all.count
          expect{
            post :create, format: 'js'
          }.to raise_error ActionController::ParameterMissing
          expect(count).to eq ProjectsDatapath.all.count
        end
      end

      it "should not respond to html" do
        expect {
          post :create, projects_datapath: @projects_datapath, format: 'html'
        }.to raise_error ActionView::MissingTemplate
      end
    end

    context "as a visitor" do
      it "should return unauthorized response" do
        post :create, share_link: @projects_datapath, format: 'js'
        expect(response).not_to be_success
        expect(response.status).to be 401
      end

      it "should not create a new projec's datapath" do
        expect{
          post :create, share_link: @projects_datapath, format: 'js'
        }.not_to change(ShareLink, :count)
      end
    end
  end

  describe "Delete 'destroy'" do
    before do
      create_projects_datapath
      FactoryGirl.create(:projects_datapath, @projects_datapath)
      @project.datapaths << @datapath
    end

    context "as a signed in manager and project owner" do
      before { sign_in @manager }

      context "with valid parameters" do
        it "should be a success" do
          delete :destroy, id: @project.id, projects_datapath: @projects_datapath, format: 'js'
          expect(response).to be_success
        end

        it "should destroy the project's datapath" do
          expect{
            delete :destroy, id: @project.id, projects_datapath: @projects_datapath, format: 'js'
          }.to change(ProjectsDatapath, :count).by(-1)
        end
      end

      context "with invalid parameters" do
        it "should not create a new project's datapath" do
          count = ProjectsDatapath.all.count
          expect{
            delete :destroy, projects_datapath: @projects_datapath, format: 'js'
          }.to raise_error ActionController::UrlGenerationError
          expect(count).to eq ProjectsDatapath.all.count
        end
      end

      it "should not respond to html" do
        expect {
          delete :destroy, id: @project.id, projects_datapath: @projects_datapath, format: 'html'
        }.to raise_error ActionView::MissingTemplate
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        delete :destroy, id: @project.id, projects_datapath: @projects_datapath, format: 'js'
        expect(response).not_to be_success
        expect(response.status).to be 401
      end

      it "should not delete the project" do
        expect{
          delete :destroy, id: @project.id, projects_datapath: @projects_datapath, format: 'js'
        }.not_to change(Project, :count)
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
          get :browser, id: @project, format: 'json'
          expect(response).to be_success
          expect(response.header['Content-Type']).to include 'application/json'
        end

        it "should use all available master datapaths" do
          controller.stub(:tree).and_return([{title: 'path', key: 1}])
          expect(controller).to receive(:generate_tree).with(Datapath.all).and_return([{}])
          get :browser, id: @project, format: 'json'
        end

        it "should render json from the generate_tree method" do
          json = [{title: nil, key: nil, selected: nil}]
          expect(controller).to receive(:generate_tree).and_return(json)
          get :browser, id: @project, format: 'json'
          expect(response.body).to eq "[{\"title\":null,\"key\":null,\"selected\":null}]"
        end
      end

      it "should not respond to html" do
        expect {
          get :browser, id: @project, format: 'html'
        }.to raise_error ActionController::UnknownFormat
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :browser, id: @project, format: 'json'
        expect(response).not_to be_success
        expect(response.status).to eq 401
      end
    end
  end

  describe "#generate_tree" do
    before do
      @datapath1 = FactoryGirl.create(:datapath)
      controller.instance_variable_set(:@project, FactoryGirl.create(:project))
    end

    it "creates nodes for all files and directories found recursively" do
      datapath2 = FactoryGirl.create(:datapath)
      datapath1_paths =  %w(/file1 /dir3/file2 /dir3/file3 /dir4/file4).collect do |dir|
        @datapath1.path + dir
      end
      datapath2_paths = [datapath2.path + "/file5"]

      expect(Dir).to receive(:glob).and_return( datapath1_paths, datapath2_paths)

      expect(controller.send(:generate_tree, [@datapath1, datapath2])).to eq [
        {title: @datapath1.path, key: @datapath1.id, expanded: true, children: [
          {title: 'file1'},
          {title: 'dir3', children: [
            {title: 'file2' },
            {title: 'file3'},
          ], folder: true},
          {title: 'dir4', children: [
            {title: 'file4'}
          ], folder: true}
        ], folder: true},
        {title: datapath2.path, key: datapath2.id, expanded: true, children: [
          {title: 'file5'}
        ], folder: true}
      ]
    end

    it "marks a path as empty when no tracks are found" do
      expect(Dir).to receive(:glob).and_return []

      expect(controller.send(:generate_tree, [@datapath1])).to eq [
        {title: @datapath1.path, key: @datapath1.id, folder: true}
      ]
    end

    it "only searches for defined formats" do
      expect(Dir).to receive(:glob).with(["#{@datapath1.path}/**/*.bw", "#{@datapath1.path}/**/*.bam"]).and_call_original
      controller.send(:generate_tree, [@datapath1])
    end

    it "marks project's datapaths as selected" do
      datapath2 = FactoryGirl.create(:datapath)
      project = FactoryGirl.create(:project, datapaths: [datapath2])
      controller.instance_variable_set(:@project, project)

      expect(controller.send(:generate_tree, [@datapath1, datapath2])).to eq [
        {title: @datapath1.path, key: @datapath1.id, folder: true},
        {title: datapath2.path, key: datapath2.id, folder: true, selected: true}
      ]
    end
  end

  describe "#add_node_to_tree" do
    context "top level nodes" do
      before { @datapath = FactoryGirl.create(:datapath) }

      it "returns the node with datapath id as key" do
        controller.instance_variable_set(:@project, FactoryGirl.create(:project))
        expect(controller.send(:add_node_to_tree, [], @datapath.path, false, @datapath.id)).to eq(
          {title: @datapath.path, key: @datapath.id}
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
      end
    end

    context "regular nodes" do
      before do
        tree = [{title: '/dir1', key: 1}]
        @parent = tree.first
        controller.instance_variable_set(:@key, 1)
      end

      it "returns the node" do
        expect(controller.send(:add_node_to_tree, @parent, '/dir2')).to eq({title: '/dir2'})
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

      it "sets the folder attribute to the parent" do
        node = controller.send(:add_node_to_tree, @parent, '/dir2')
        expect(@parent).to have_key :folder
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
      end
    end
  end
end
