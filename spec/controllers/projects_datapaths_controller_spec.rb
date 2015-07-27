require 'rails_helper'

RSpec.describe ProjectsDatapathsController do
  describe "filters" do
    it { is_expected.to use_before_action :authenticate_user! }
  end

  before { @manager = FactoryGirl.create(:manager) }

  describe "Post 'create'" do
    before { @projects_datapath_attr = FactoryGirl.attributes_for(:projects_datapath) }

    context "as a signed in manager and project owner" do
      before { sign_in @manager }

      context "project datapath creation" do
        it { is_expected.to permit(:project_id, :datapath_id, :path, :name).for(:create, params: {format: :json}) }

        context "with valid parameters" do
          before { @projects_datapath_attr.merge!(datapath_id: FactoryGirl.create(:datapath).id) }

          it "should be a success" do
            post :create, projects_datapath: @projects_datapath_attr, format: :json
            expect(response).to be_success
            expect(response.header['Content-Type']).to include 'application/json'
            json = JSON.parse(response.body)
            new_projects_datapath = ProjectsDatapath.last
            expect(json).to eq ({"type" => "projects_datapath", "id" => new_projects_datapath.id, "name" => new_projects_datapath.name})
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
          before { @projects_datapath_attr.merge!(datapath_id: 9999) }

          it "should raise not found error" do
            post :create, projects_datapath: @projects_datapath_attr, format: :json
            expect(response.status).to eq 400
            expect(response.header['Content-Type']).to include 'application/json'
            json = JSON.parse(response.body)
            expect(json['status']).to eq 'error'
            expect(json['message']).to eq 'Datapath datapath must exist'
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
    before { @projects_datapath = FactoryGirl.create(:projects_datapath) }

    context "as a signed in manager and project owner" do
      before { sign_in @manager }

      context "with valid parameters" do
        it "should be a success" do
          delete :destroy, id: @projects_datapath, format: :json
          expect(response).to be_success
          expect(response.header['Content-Type']).to include 'application/json'
          json = JSON.parse(response.body)
          expect(json['status']).to eq 'success'
          expect(json['message']).to eq 'OK'
        end

        it "should destroy the project's datapath" do
          expect{
            delete :destroy, id: @projects_datapath, format: :json
          }.to change(ProjectsDatapath, :count).by(-1)
        end
      end

      context "with invalid parameters" do
        context "non-existance projects datapath" do
          before { allow_any_instance_of(ProjectsDatapath).to receive(:destroy).and_return(false) }

          it "should raise record not found error" do
            delete :destroy, id: @projects_datapath, format: :json
            expect(response.status).to eq 400
            expect(response.header['Content-Type']).to include 'application/json'
            json = JSON.parse(response.body)
            expect(json['status']).to eq 'error'
            expect(json['message']).to eq 'Record not deleted'
          end

          it "should not destroy the project's datapath" do
            expect{
              delete :destroy, id: @projects_datapath, format: :json
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
          get :browser, project: @project, format: :json
          # get :browser, id: @project, format: :json
          expect(response).to be_success
          expect(response.header['Content-Type']).to include 'application/json'
        end

        it "should use the right project" do
          get :browser, project: @project, format: :json
          # get :browser, id: @project, format: :json
          expect(assigns(:project)).to eq @project
        end

        # it "should use the project owners datapaths" do
        #   @project.owner.datapaths << FactoryGirl.create(:datapath)
        #   expect(controller).to receive(:generate_tree).with(@project.owner.datapaths)
        #   get :browser, project: @project, format: :json
        # end

        # it "should render json from the generate_tree method" do
        #   expect(controller).to receive(:generate_tree).and_return('fakejson')
        #   get :browser, project: @project, format: :json
        #   expect(response.body).to eq 'fakejson'
        # end
      end

      it "should not respond to html" do
        expect {
          get :browser, project: @project, format: :html
          # get :browser, id: @project, format: :html
        }.to raise_error ActionController::UnknownFormat
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :browser, project: @project, format: :json
        # get :browser, id: @project, format: :json
        expect(response.status).to eq 401
        expect(response.header['Content-Type']).to include 'application/json'
        json = JSON.parse(response.body)
        expect(json['error']).to eq I18n.t('devise.failure.unauthenticated')
      end
    end
  end

  # TODO: review when tracks are added to fancytree
  describe "#generate_tree" do
    before do
      @datapath1 = FactoryGirl.create(:datapath)
      @project = FactoryGirl.create(:project)
      controller.instance_variable_set(:@project, @project)
    end

    context "can manage the project" do
      before do
        allow(controller).to receive(:cannot?).and_return(false)
        allow(controller).to receive(:can?).with(:manage, kind_of(Project)).and_return(true)
        allow(controller).to receive(:can?).with(:update_tracks, kind_of(Project)).and_return(true)
      end

      it "creates nodes for all files and directories found recursively" do
        datapath1_paths =  %w(/dir1/ /dir2/dir3/ /dir2/dir4/ /dir5/dir6/).collect do |dir|
          @datapath1.path + dir
        end

        datapath2 = FactoryGirl.create(:datapath)
        folder_path = datapath2.path + "/dir6/"
        track_path = folder_path + "track1.bam"
        cp_track track_path
        datapath2_paths = [folder_path, track_path]

        expect(Dir).to receive(:glob).and_return(datapath1_paths, datapath2_paths)

        expect(controller.send(:generate_tree, [@datapath1, datapath2])).to eq [
          {title: @datapath1.path, key: @datapath1.id, folder: true, children: [
            {title: "dir1", folder: true},
            {title: "dir2", folder: true, children: [
              {title: "dir3", folder: true},
              {title: "dir4", folder: true}]},
            {title: "dir5", folder: true, children: [
              {title: "dir6", folder: true}
            ]}
          ]},
          {title: datapath2.path, key: datapath2.id, folder: true, children: [
            {title: "dir6", folder: true, children: [
              {title: "track1.bam", hideCheckbox: true}
            ]}
          ]}
        ]
        File.unlink track_path if File.exist?(track_path)
      end

      it "marks a path as empty when no tracks are found" do
        expect(Dir).to receive(:glob).and_return [@datapath1.path]

        expect(controller.send(:generate_tree, [@datapath1])).to eq [
          {title: @datapath1.path, key: @datapath1.id, folder: true}
        ]
      end

      it "marks project's datapaths as selected and expanded" do
        datapath2 = FactoryGirl.create(:datapath)
        project = FactoryGirl.create(:project)
        projects_datapath = FactoryGirl.create(:projects_datapath, project: project, datapath: datapath2, path: "")
        projects_datapaths = %w(dir1 dir1/subdir2/subdir3).collect do |sub_dir|
          FactoryGirl.create(:projects_datapath, datapath: @datapath1, project: project, path: sub_dir)
        end
        track = FactoryGirl.create(:track, projects_datapath: projects_datapaths.last)
        project.reload

        controller.instance_variable_set(:@project, project)
        allow(controller).to receive_message_chain(:view_context, :link_to_igv).and_return('igv_url')

        expect(controller.send(:generate_tree, [@datapath1, datapath2])).to eq [
          {title: @datapath1.path, key: @datapath1.id, expanded: true, folder: true,
            children: [
              {title: "dir1", expanded: true, folder: true, selected: true, object: {projects_datapath: {id: projects_datapaths.first.id, name: projects_datapaths.first.name}},
                children: [
                  {title: "subdir2", expanded: true, folder: true,
                    children: [
                      {title: "subdir3", expanded: true, folder: true, selected: true, object: {projects_datapath: {id: projects_datapaths.last.id, name: projects_datapaths.last.name}},
                        children: [
                          {title: "tracks", expanded: true, folder: true,
                            children: [
                              {title: Pathname.new(track.path).basename.to_s, selected: true, object: {track: {id: track.id, name: track.name, genome: track.genome, igv: 'igv_url'}}
                              }]
                          }]
                      }]
                  }]
              }]
          },
          {title: datapath2.path, key: datapath2.id, selected: true, object:  {projects_datapath: {id: projects_datapath.id, name: projects_datapath.name}}, folder: true}
        ]
      end
    end

    context "project user" do
      it "only creates nodes where the node, a parent, or a child is selected" do
        projects_datapath1 = FactoryGirl.create(:projects_datapath, datapath: @datapath1, project: @project, path: (File.join 'dir1', 'subdir1'))
        FileUtils.mkdir(File.join(@datapath1.path, 'not_shown_dir')) unless File.exist?(File.join(@datapath1.path, 'unshown_dir'))
        cp_track File.join @datapath1.path, 'not_shown_track.bam'
        projects_datapath2 = FactoryGirl.create(:projects_datapath, project: @project, path: '')
        projects_datapath3 = FactoryGirl.create(:projects_datapath, project: @project, path: '')
        track = FactoryGirl.create(:track, projects_datapath: projects_datapath2, path: (File.join 'dir1', 'dir2', 'track1.bam'))

        allow(controller).to receive_message_chain(:view_context, :link_to_igv).and_return('igv_url')

        expect(controller.send(:generate_tree, [@datapath1, projects_datapath2.datapath, projects_datapath3.datapath])).to eq [
          {title: @datapath1.path, key: @datapath1.id, expanded: true, hideCheckbox: true, folder: true,
            children: [{title: "dir1", expanded: true, hideCheckbox: true, folder: true,
              children: [{title: "subdir1", hideCheckbox: true, folder: true, selected: true, object: {projects_datapath: {id: projects_datapath1.id, name: projects_datapath1.name}}
              }]
            }]
          },
          {title: projects_datapath2.full_path, key: projects_datapath2.datapath.id, expanded: true, hideCheckbox: true, folder: true, selected: true, object: {projects_datapath: {id: projects_datapath2.id, name: projects_datapath2.name}},
            children: [{title: "dir1", expanded: true, hideCheckbox: true, folder: true,
              children: [{title: "dir2", expanded: true, hideCheckbox: true, folder: true,
                children: [{title: "track1.bam", selected: true, object: {track: {id: track.id, name: track.name, genome: track.genome, igv: 'igv_url'}}, hideCheckbox: true
                }]
              }]
            }]
          },
          {title: projects_datapath3.full_path, key: projects_datapath3.datapath.id, hideCheckbox: true, folder: true, selected: true, object: {projects_datapath: {id: projects_datapath3.id, name: projects_datapath3.name}}}
        ]
      end
    end

    context "read only users" do
      it "skips unselected tracks" do
        allow(controller).to receive(:cannot?).and_return(false)
        allow(controller).to receive(:can?).with(:manage, kind_of(Project)).and_return(true)
        allow(controller).to receive(:can?).with(:update_tracks, kind_of(Project)).and_return(false)
        allow(controller).to receive_message_chain(:view_context, :link_to_igv).and_return('igv_url')

        folder_path = @datapath1.path + "/dir1/"
        projects_datapath = FactoryGirl.create(:projects_datapath, project: @project, datapath: @datapath1, path: "dir1")
        selected_track = FactoryGirl.create(:track, projects_datapath: projects_datapath, path: "track1.bam")
        track_path = folder_path + "track2.bam"
        cp_track track_path
        datapath1_paths = [folder_path, selected_track.full_path, track_path]

        expect(Dir).to receive(:glob).and_return(datapath1_paths)

        expect(controller.send(:generate_tree, [@datapath1])).to eq [
          {title: @datapath1.path, key: @datapath1.id, expanded: true, folder: true, children: [
            {title: "dir1", folder: true, selected: true, object: {projects_datapath: {id: projects_datapath.id, name: projects_datapath.name}}, expanded: true,
              children: [
                {title: "track1.bam", selected: true, object: {track: {id: selected_track.id, name: selected_track.name, genome: selected_track.genome, igv: 'igv_url'}}}
              ]}
          ]}
        ]

        File.unlink selected_track.path if File.exist?(selected_track.path)
        File.unlink track_path if File.exist?(track_path)
      end
    end
  end

  describe "#top_level_tree" do
    it "should add allowed datapaths" do
      datapaths = FactoryGirl.create_list(:datapath, 2)
      project = FactoryGirl.create(:project)
      controller.instance_variable_set(:@project, project)
      expect(controller).to receive(:allowed_datapaths).and_return(datapaths)

      expect(controller.send :top_level_tree).to eq [
        {title: datapaths[0].path, object: {datapath_id: datapaths[0].id}, folder: true, lazy: true},
        {title: datapaths[1].path, object: {datapath_id: datapaths[1].id}, folder: true, lazy: true}
      ]
    end

    it "should add selected projects_datapaths" do
      datapaths = FactoryGirl.create_list(:datapath, 2)
      project = FactoryGirl.create(:project)
      projects_datapath1 = FactoryGirl.create(:projects_datapath, project: project, datapath: datapaths[0], path: '')
      projects_datapath2 = FactoryGirl.create(:projects_datapath, project: project, datapath: datapaths[1], path: 'subdir')

      controller.instance_variable_set(:@project, project)
      expect(controller).to receive(:allowed_datapaths).and_return(project.datapaths)

      expect(controller.send :top_level_tree).to eq [
        {title: datapaths[0].path, folder: true, lazy: true, selected: true, object: {datapath_id: datapaths[0].id, type: 'projects_datapath', id: projects_datapath1.id, name: projects_datapath1.name}, expanded: true },
        {title: datapaths[1].path, folder: true, lazy: true, object: {datapath_id: datapaths[1].id}, expanded: true, children: [
          {title: 'subdir', folder: true, lazy: true, selected: true, expanded: true, object: {type: 'projects_datapath', id: projects_datapath2.id, name: projects_datapath2.name}}
        ]}
      ]
    end

    it "should add selected tracks" do
      datapath = FactoryGirl.create(:datapath)
      project = FactoryGirl.create(:project)
      projects_datapath = FactoryGirl.create(:projects_datapath, project: project, datapath: datapath, path: 'dir1/dir11')
      track1111 = FactoryGirl.create(:track, projects_datapath: projects_datapath, path: 'dir111/track1111.bam')
      track1112 = FactoryGirl.create(:track, projects_datapath: projects_datapath, path: 'dir111/track1112.bam')

      controller.instance_variable_set(:@project, project)
      expect(controller).to receive(:allowed_datapaths).and_return(project.datapaths)
      allow(controller).to receive_message_chain(:view_context, :link_to_igv).and_return('igv_url')

      expect(controller.send :top_level_tree).to eq [
        {title: datapath.path, object: {datapath_id: datapath.id}, folder: true, lazy: true, expanded: true, children: [
          {title: 'dir1', folder: true, lazy: true, expanded: true, children: [
            {title: 'dir11', folder: true, lazy: true, selected: true, object: {type: 'projects_datapath', id: projects_datapath.id, name: projects_datapath.name}, expanded: true, children: [
              {title: 'dir111', folder: true, lazy: true, expanded: true, children: [
                {title: 'track1111.bam', selected: true, object: {type: 'track', id: track1111.id, name: track1111.name, genome: track1111.genome, igv: 'igv_url'}},
                {title: 'track1112.bam', selected: true, object: {type: 'track', id: track1112.id, name: track1112.name, genome: track1112.genome, igv: 'igv_url'}}
              ]}
            ]}
          ]}
        ]}
      ]
    end
  end

  describe "#fill_in_tree" do
    it "should fill in directories and tracks" do
      tree = [
        {title: 'tmp/tests', folder: true, lazy: true, expanded: true, children: [
          {title: 'dir1', folder: true, lazy: true, expanded: true, children: [
            {title: 'dir11', folder: true, lazy: true, expanded: true, children: [
              {title: 'dir111', folder: true, lazy: true, expanded: true, children: [
                {title: 'track1111.bam', selected: true}
              ]}
            ]}
          ]}
        ]}
      ]

      {
        File.join('tmp/tests')                            => ['dir1/', 'dir2/', 'track1.bam'],
        File.join('tmp/tests', 'dir1')                    => ['dir11/', 'dir12/', 'track11.bam'],
        File.join('tmp/tests', 'dir1', 'dir11')           => ['dir111/', 'dir112/', 'track111.bam'],
        File.join('tmp/tests', 'dir1', 'dir11', 'dir111') => ['track1111.bam', 'dir1111/', 'track1112.bam']
      }.each do |path, items|
        allow_any_instance_of(FilebrowserService).to receive(:entries).with(path).and_return(items)
      end

      expect(controller.send :fill_in_tree, tree).to eq [
        {title: 'tmp/tests', folder: true, lazy: true, expanded: true, children: [
          {title: 'dir1', folder: true, lazy: true, expanded: true, children: [
            {title: 'dir11', folder: true, lazy: true, expanded: true, children: [
              {title: 'dir111', folder: true, lazy: true, expanded: true, children: [
                {title: 'track1111.bam', selected: true},
                {title: 'dir1111', folder: true, lazy: true},
                {title: 'track1112.bam'}
              ]},
              {title: 'dir112', folder: true, lazy: true},
              {title: 'track111.bam'}
            ]},
            {title: 'dir12', folder: true, lazy: true},
            {title: 'track11.bam'}
          ]},
          {title: 'dir2', folder: true, lazy: true},
          {title: 'track1.bam'}
        ]}
      ]
    end

    it "should not expand node without selected children" do
      tree = [
        {title: 'tmp/tests', folder: true, lazy: true}
      ]

      allow_any_instance_of(FilebrowserService).to receive(:entries).with(File.join('tmp/tests')).and_return(['dir1/', 'track1.bam'])

      expect(controller.send :fill_in_tree, tree).to eq [
        {:title=>"tmp/tests", :folder=>true, :lazy=>true}
      ]
    end

    it "should load direct children of selected folder node" do
      tree = [
        {title: 'tmp/tests', folder: true, lazy: true, selected: true}
      ]

      allow_any_instance_of(FilebrowserService).to receive(:entries).with(File.join('tmp/tests')).and_return(['dir1/', 'track1.bam'])

      expect(controller.send :fill_in_tree, tree).to eq [
        {:title=>"tmp/tests", :folder=>true, :lazy=>true, :selected=>true, :children=>[
          {:title=>"dir1", :folder=>true, :lazy=>true},
          {:title=>"track1.bam"}
        ]}
      ]
    end

    it "should hide checkboxes on sibling files of selected folders" do
      tree = [
        {title: 'tmp/tests', folder: true, lazy: true, expanded: true, children: [
          {title: 'dir1', folder: true, lazy: true, expanded: true, selected: true}
        ]}
      ]

      {
        File.join('tmp/tests')                            => ['dir1/', 'track1.bam'],
        File.join('tmp/tests', 'dir1')                    => ['track11.bam']
        }.each do |path, items|
        allow_any_instance_of(FilebrowserService).to receive(:entries).with(path).and_return(items)
      end

      expect(controller.send :fill_in_tree, tree).to eq [
        {:title=>"tmp/tests", :folder=>true, :lazy=>true, :expanded=>true, :children=>[
          {:title=>"dir1", :folder=>true, :lazy=>true, :expanded=>true, :selected=>true, :children=>[
            {:title=>"track11.bam"}
          ]},
          {:title=>"track1.bam", :hideCheckbox=>true}
        ]}
      ]
    end
  end

  describe "#allowed_datapaths" do
    before do
      @project = FactoryGirl.create(:project)
      @owner = @project.owner
      @owner.datapaths << FactoryGirl.create_list(:datapath, 2)
      @project.datapaths << @owner.datapaths.first

      controller.instance_variable_set(:@project, @project)
    end

    context "as project manager" do
      it "should return all owner's datapaths" do
        sign_in @owner
        expect(controller.send :allowed_datapaths).to eq @owner.datapaths
      end
    end

    context "as regular user" do
      it "should only return allowed project's datapaths" do
        sign_in FactoryGirl.create(:user)
        expect(controller.send :allowed_datapaths).to eq @project.datapaths
      end
    end
  end

  describe "#add_path" do
    it "adds a path to a node" do
      node = {}

      result = controller.send :add_path, node, 'path'
      expect(result).to eq Hash(title: 'path', folder: true, lazy: true, selected: true, expanded: true)
      expect(node).to eq Hash(expanded: true, children: [result])
    end

    it "adds multiple paths to a node" do
      node = {}

      result = controller.send :add_path, node, 'path1/path2'
      expect(result).to eq Hash(title: 'path2', folder: true, lazy: true, selected: true, expanded: true)
      expect(node).to eq Hash(expanded: true, children: [
        {title: 'path1', folder: true, lazy: true, expanded: true, children: [
          result
        ]}
      ])
    end

    it "adds multiple subpaths to a node" do
      node = {}

      result1 = controller.send :add_path, node, 'path/path1'
      expect(result1).to eq Hash(title: 'path1', folder: true, lazy: true, selected: true, expanded: true)

      result2 = controller.send :add_path, node, 'path/path2'
      expect(result2).to eq Hash(title: 'path2', folder: true, lazy: true, selected: true, expanded: true)

      expect(node).to eq Hash(expanded: true, children: [
        {title: 'path', folder: true, lazy: true, expanded: true, children: [
          result1,
          result2
        ]}
      ])
    end

    it "add path with a track to a node" do
      node = {}

      result = controller.send :add_path, node, 'path1/track.bam', true
      expect(result).to eq Hash(title: 'track.bam', selected: true)
      expect(node).to eq Hash(expanded: true, children: [
        {title: 'path1', folder: true, lazy: true, expanded: true, children: [
          result
        ]}
      ])
    end

    it "raises ArgumentError when path is an empty string" do
      node = {}

      expect {
        controller.send :add_path, node, ''
      }.to raise_error(ArgumentError)
    end
  end

  describe "#checkbox_abilities" do
    context "as a user" do
      it "should hide checkboxes on folders" do
        allow(controller).to receive(:cannot?).and_return(true)
        tree = [
          {title: 'dir1', folder: true, lazy: true, children: [
            {title: 'dir1', folder: true, lazy: true}
          ]}
        ]
        result = controller.send :checkbox_abilities, tree

        expect(result).to eq [
          {:title=>"dir1", :folder=>true, :lazy=>true, :hideCheckbox=>true, :children=>[
            {:title=>"dir1", :folder=>true, :lazy=>true, :hideCheckbox=>true}
          ]}
        ]
      end

      it "should hide checkboxes on unowned tracks" do
        project = FactoryGirl.create(:project)
        track = FactoryGirl.create(:track, project: project)
        controller.instance_variable_set(:@project, project)
        allow(controller).to receive(:cannot?).and_return(true)

        tree = [
          {title: 'track1.bam', lazy: true, selected: true, object: {id: track.id}}
        ]
        result = controller.send :checkbox_abilities, tree

        expect(result).to eq [
          {:title=>"track1.bam", :lazy=>true, :selected=>true, :object=>{:id=>track.id}, :hideCheckbox=>true}
        ]
      end
    end
  end

  describe "#add_node_to_tree" do
    context "top level nodes" do
      before do
        allow(controller).to receive(:cannot?).and_return(false)
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

        it "has a object attribute if requested" do
          projects_datapath = FactoryGirl.create(:projects_datapath)
          expect(controller.send(:add_node_to_tree, [], '/dir1', true, 1, projects_datapath)).
            to eq({title: "/dir1", key: 1, expanded: true, selected: true, object: {projects_datapath: {id: projects_datapath.id, name: projects_datapath.name}}, folder: true})
        end
      end
    end

    context "regular nodes" do
      before do
        tree = [{title: '/dir1', key: 1}]
        @parent = tree.first
        controller.instance_variable_set(:@key, 1)
        allow(controller).to receive(:cannot?).and_return(false)
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

        it "has a object attribute if requested" do
          projects_datapath = FactoryGirl.create(:projects_datapath)
          expect(controller.send(:add_node_to_tree, @parent, '/dir2', false, nil, projects_datapath)[:object]).
            to eq({projects_datapath: {id: projects_datapath.id, name: projects_datapath.name}})
        end
      end
    end

    context "regular users" do
      before do
        tree = [{title: '/dir1', key: 1}]
        @parent = tree.first
      end

      context "directories" do
        before { allow(controller).to receive(:cannot?).and_return(true) }

        context "top level nodes" do
          it "hides the node checkbox" do
            controller.instance_variable_set(:@project, FactoryGirl.create(:project))
            expect(controller.send(:add_node_to_tree, [], '/dir1')).
              to eq({title: "/dir1", hideCheckbox: true, folder: true})
          end
        end

        context "regular nodes" do
          it "hides the node checkbox for folders" do
            expect(controller.send(:add_node_to_tree, @parent, '/dir2')).
              to eq({title: "/dir2", hideCheckbox: true, folder: true})
          end
        end
      end

      context "files" do
        it "shows the checkbox for unassigned files" do
          allow(controller).to receive(:cannot?).and_return(true)
          expect(controller.send(:add_node_to_tree, @parent, '/track1.bam', false, nil, nil, false)).
            to eq({title: "/track1.bam"})
        end

        it "shows checkbox for owned files" do
          allow(controller).to receive(:cannot?).and_return(false)
          expect(controller.send(:add_node_to_tree, @parent, '/track1.bam', false, nil, nil, false)).
            to eq({title: "/track1.bam"})
        end

        it "does not show checkbox for assigned files owned by another" do
          allow(controller).to receive(:cannot?).and_return(true, true)
          allow(controller).to receive_message_chain(:view_context, :link_to_igv).and_return('igv_url')
          track = FactoryGirl.create(:track)
          expect(controller.send(:add_node_to_tree, @parent, '/track1.bam', true, nil, Track.last)).
            to eq({expanded: true, selected: true, hideCheckbox: true, object: {track: {id: track.id, name: track.name, genome: track.genome, igv: 'igv_url'}}, title: "/track1.bam"})
        end
      end
    end
  end
end
