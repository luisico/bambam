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

  describe "GET 'browser'" do
    context "as a signed in user" do
      before do
        user = FactoryGirl.create(:user)
        sign_in user
      end

      context "responds to json" do
        it "should be successful" do
          get :browser, format: 'json'
          expect(response).to be_success
          expect(response.header['Content-Type']).to include 'application/json'
        end

        it "should use all available master datapaths" do
          expect(controller).to receive(:generate_tree).with(Datapath.all)
          get :browser, format: 'json'
        end

        it "should render json from the generate_tree method" do
          expect(controller).to receive(:generate_tree).and_return("fakejson")
          get :browser, format: 'json'
          expect(response.body).to eq 'fakejson'
        end
      end

      it "should not respond to html" do
        expect {
          get :browser, format: 'html'
        }.to raise_error ActionController::UnknownFormat
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :browser, format: 'json'
        expect(response).not_to be_success
        expect(response.status).to eq 401
      end
    end
  end

  describe "#generate_tree" do
    before { @datapath1 = FactoryGirl.create(:datapath) }

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
  end

  describe "#add_node_to_tree" do
    context "top level nodes" do
      before { @datapath = FactoryGirl.create(:datapath) }

      it "returns the node with datapath id as key" do
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
