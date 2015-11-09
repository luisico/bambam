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
          expect(response).to be_success
          expect(response.header['Content-Type']).to include 'application/json'
        end

        it "should use the right project" do
          get :browser, project: @project, format: :json
          expect(assigns(:project)).to eq @project
        end
      end

      it "should not respond to html" do
        expect {
          get :browser, project: @project, format: :html
        }.to raise_error ActionController::UnknownFormat
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :browser, project: @project, format: :json
        expect(response.status).to eq 401
        expect(response.header['Content-Type']).to include 'application/json'
        json = JSON.parse(response.body)
        expect(json['error']).to eq I18n.t('devise.failure.unauthenticated')
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
      allow(controller).to receive(:can?).and_return(true)
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

    it "should not expand node missing from disk" do
      tree = [
        {title: 'tmp/tests', folder: true, lazy: true, on_disk: false}
      ]

      allow_any_instance_of(FilebrowserService).to receive(:entries).with(File.join('tmp/tests')).and_return(['dir1/', 'track1.bam'])

      expect(controller.send :fill_in_tree, tree).to eq [
        {:title=>"tmp/tests", :folder=>true, :lazy=>true, on_disk: false}
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
      allow(controller).to receive(:can?).and_return(true)
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

    context "users" do
      before { allow(controller).to receive(:can?).and_return(false) }

      it "should show sibling files to selected files" do
        tree = [
          {title: 'tmp/tests', folder: true, lazy: true, expanded: true, children: [
            {title: 'dir1', folder: true, lazy: true, expanded: true, selected: true, children: [
              {title: 'track11.bam', selected: true}
            ]}
          ]}
        ]

        {
          File.join('tmp/tests')                            => ['dir1/'],
          File.join('tmp/tests', 'dir1')                    => ['track11.bam', 'track12.bam', 'track13.bam'],
        }.each do |path, items|
          allow_any_instance_of(FilebrowserService).to receive(:entries).with(path).and_return(items)
        end

        expect(controller.send :fill_in_tree, tree).to eq [
          {title: 'tmp/tests', folder: true, lazy: true, expanded: true, children: [
            {title: 'dir1', folder: true, lazy: true, expanded: true, selected: true, children: [
              {title: 'track11.bam', selected: true},
              {title: 'track12.bam'},
              {title: 'track13.bam'},
            ]},
          ]}
        ]
      end

      it "should should not show users sibling folders of checked folder" do
        tree = [
          {title: 'tmp/tests', folder: true, lazy: true, expanded: true, children: [
            {title: 'dir1', folder: true, lazy: true, expanded: true, selected: true}
          ]}
        ]

        {
          File.join('tmp/tests')                            => ['dir1/', 'dir2/'],
          File.join('tmp/tests', 'dir1')                    => ['track11.bam']
          }.each do |path, items|
          allow_any_instance_of(FilebrowserService).to receive(:entries).with(path).and_return(items)
        end

        expect(controller.send :fill_in_tree, tree).to eq [
          {title: 'tmp/tests', folder: true, lazy: true, expanded: true, children: [
            {title: 'dir1', folder: true, lazy: true, expanded: true, selected: true, :children=>[
              {:title=>"track11.bam"}
            ]}
          ]}
        ]
      end

      it "should should not show users sibling files of checked folder" do
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
          {title: 'tmp/tests', folder: true, lazy: true, expanded: true, children: [
            {title: 'dir1', folder: true, lazy: true, expanded: true, selected: true, :children=>[
              {:title=>"track11.bam"}
            ]}
          ]}
        ]
      end

      it "should not show siblings of checked folder parents" do
        tree = [
          {title: 'tmp/tests', folder: true, lazy: true, expanded: true, children: [
            {title: 'dir1', folder: true, lazy: true, expanded: true, children: [
              {title: 'dir11', folder: true, lazy: true, expanded: true, selected: true}
              ]}
          ]}
        ]

        {
          File.join('tmp/tests')                            => ['dir1/', 'dir2/'],
          File.join('tmp/tests', 'dir1')                    => ['dir11'],
          File.join('tmp/tests', 'dir1', 'dir11')           => ['track111.bam']
          }.each do |path, items|
          allow_any_instance_of(FilebrowserService).to receive(:entries).with(path).and_return(items)
        end

        expect(controller.send :fill_in_tree, tree).to eq [
          {:title=>"tmp/tests", :folder=>true, :lazy=>true, :expanded=>true, :children=>[
            {:title=>"dir1", :folder=>true, :lazy=>true, :expanded=>true, :children=>[
              {:title=>"dir11", :folder=>true, :lazy=>true, :expanded=>true, :selected=>true, :children=>[
                {:title=>"track111.bam"}
              ]}
            ]}
          ]}
        ]
      end
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
      allow(File).to receive(:directory?).and_return(true)
      node = {}

      result = controller.send :add_path, node, 'path', false, 'parent'
      expect(result).to eq Hash(title: 'path', folder: true, lazy: true, selected: true, expanded: true)
      expect(node).to eq Hash(expanded: true, children: [result])
    end

    it "adds multiple paths to a node" do
      allow(File).to receive(:directory?).and_return(true)
      node = {}

      result = controller.send :add_path, node, 'path1/path2', false, 'parent'
      expect(result).to eq Hash(title: 'path2', folder: true, lazy: true, selected: true, expanded: true)
      expect(node).to eq Hash(expanded: true, children: [
        {title: 'path1', folder: true, lazy: true, expanded: true, children: [
          result
        ]}
      ])
    end

    it "adds multiple subpaths to a node" do
      allow(File).to receive(:directory?).and_return(true)
      node = {}

      result1 = controller.send :add_path, node, 'path/path1', false, 'parent'
      expect(result1).to eq Hash(title: 'path1', folder: true, lazy: true, selected: true, expanded: true)

      result2 = controller.send :add_path, node, 'path/path2', false, 'parent'
      expect(result2).to eq Hash(title: 'path2', folder: true, lazy: true, selected: true, expanded: true)

      expect(node).to eq Hash(expanded: true, children: [
        {title: 'path', folder: true, lazy: true, expanded: true, children: [
          result1,
          result2
        ]}
      ])
    end

    it "add path with a track to a node" do
      allow(File).to receive(:directory?).and_return(true)
      allow(File).to receive(:exist?).and_return(true)
      node = {}

      result = controller.send :add_path, node, 'path1/track.bam', true, 'parent'
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

    it "adds path missing from disk" do
      allow(File).to receive(:directory?).and_return(false)
      node = {}

      result = controller.send :add_path, node, 'path', false, 'parent'
      expect(result).to eq Hash(title: 'path', folder: true, lazy: true, selected: true, expanded: true, iconclass: 'missing')
      expect(node).to eq Hash(expanded: true, children: [result])
    end

    it "adds file missing from disk" do
      allow(File).to receive(:directory?).and_return(true)
      allow(File).to receive(:exist?).and_return(false)
      node = {}

      result = controller.send :add_path, node, 'path1/track.bam', true, 'parent'
      expect(result).to eq Hash(title: 'track.bam', selected: true, iconclass: 'missing')
      expect(node).to eq Hash(expanded: true, children: [
        {title: 'path1', folder: true, lazy: true, expanded: true, children: [
          result
        ]}
      ])
    end
  end

  describe "#checkbox_abilities" do
    context "folders" do
      before do
        @tree = [
          {title: 'dir1', folder: true, lazy: true, children: [
            {title: 'dir1', folder: true, lazy: true}
          ]}
        ]
      end

      it "should show checkboxes on folders for project managers" do
        allow(controller).to receive(:cannot?).and_return(false)
        result = controller.send :checkbox_abilities, @tree

        expect(result).to eq [
          {:title=>"dir1", :folder=>true, :lazy=>true, :children=>[
            {:title=>"dir1", :folder=>true, :lazy=>true}
          ]}
        ]
      end

      it "should hide checkboxes on folders for project users" do
        allow(controller).to receive(:cannot?).and_return(true)
        result = controller.send :checkbox_abilities, @tree

        expect(result).to eq [
          {:title=>"dir1", :folder=>true, :lazy=>true, :hideCheckbox=>true, :children=>[
            {:title=>"dir1", :folder=>true, :lazy=>true, :hideCheckbox=>true}
          ]}
        ]
      end
    end

    context "files" do
      context "selected and unowned" do
        before do
          project = FactoryGirl.create(:project)
          @track = FactoryGirl.create(:track, project: project)
          controller.instance_variable_set(:@project, project)

          @tree = [
            {title: 'track1.bam', lazy: true, selected: true, object: {id: @track.id}}
          ]
        end

        it "should show checkboxes for project managers" do
          allow(controller).to receive(:cannot?).and_return(false)
          result = controller.send :checkbox_abilities, @tree

          expect(result).to eq [
            {:title=>"track1.bam", :lazy=>true, :selected=>true, :object=>{:id=>@track.id}}
          ]
        end

        it "should hide checkboxes for project users" do
          allow(controller).to receive(:cannot?).and_return(true)
          result = controller.send :checkbox_abilities, @tree

          expect(result).to eq [
            {:title=>"track1.bam", :lazy=>true, :selected=>true, :object=>{:id=>@track.id}, :hideCheckbox=>true}
          ]
        end
      end
    end

    context "unselected" do
      it "should hide checkbox when there is no selected parent" do
        allow(controller).to receive(:cannot?).and_return(false)
        tree = [
          {title: 'dir1', folder: true, lazy: true, children: [
            {title: 'dir11', folder: true, lazy: true, children:[
              {title: 'track111.bam'}
            ]}
          ]}
        ]
        result = controller.send :checkbox_abilities, tree

        expect(result).to eq [
          {title: 'dir1', folder: true, lazy: true, children: [
            {title: 'dir11', folder: true, lazy: true, children:[
              {title: 'track111.bam', hideCheckbox: true}
            ]}
          ]}
        ]
      end

      it "should show checkbox when there is a selected parent" do
        allow(controller).to receive(:cannot?).and_return(false)
        allow(controller).to receive(:can?).and_return(true)
        tree = [
          {title: 'dir1', folder: true, lazy: true, selected: true, children: [
            {title: 'dir11', folder: true, lazy: true, children:[
              {title: 'track111.bam'}
            ]}
          ]}
        ]
        result = controller.send :checkbox_abilities, tree

        expect(result).to eq [
          {title: 'dir1', folder: true, lazy: true, selected: true, children: [
            {title: 'dir11', folder: true, lazy: true, children:[
              {title: 'track111.bam'}
            ]}
          ]}
        ]
      end
    end

    context "read-only users" do
      it "should hide checkboxes" do
        allow(controller).to receive(:cannot?).and_return(false)
        allow(controller).to receive(:can?).and_return(false)
        tree = [
          {title: 'dir1', folder: true, lazy: true, selected: true, children: [
            {title: 'dir11', folder: true, lazy: true, children:[
              {title: 'track111.bam'}
            ]}
          ]}
        ]
        result = controller.send :checkbox_abilities, tree

        expect(result).to eq [
          {title: 'dir1', folder: true, lazy: true, selected: true, children: [
            {title: 'dir11', folder: true, lazy: true, children:[
              {title: 'track111.bam', :hideCheckbox=>true}
            ]}
          ]}
        ]
      end
    end
  end
end
