class ProjectsDatapathsController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource

  respond_to :json

  def create
    @projects_datapath = ProjectsDatapath.new(projects_datapath_params)
    if @projects_datapath.save
      render json: {projects_datapath: {id: @projects_datapath.id, name: @projects_datapath.name}}, status: 200
    else
      message = @projects_datapath.errors.collect {|name, msg| msg }.join(';')
      render json: {status: :error, message: message}, status: 400
    end
  end

  def destroy
    @projects_datapath = ProjectsDatapath.find_by_id(params[:id])
    if @projects_datapath && @projects_datapath.destroy
      render json: {status: :success, message: 'OK' }, status: 200
    else
      render json: {status: :error, message: 'file system error'}, status: 400
    end
  end

  def browser
    @project = Project.find(params[:id])
    tree = generate_tree @project.owner.datapaths
    respond_with tree
  end

  private

  def projects_datapath_params
    params.require(:projects_datapath).permit(:project_id, :datapath_id, :sub_directory, :name)
  end

  def generate_tree(datapaths=[])
    formats = %w(*.bw *.bam /)
    tree = []

    datapaths.each do |datapath|
      dirname = File.dirname(datapath.path)
      globs = formats.map{ |f| File.join(datapath.path, "**", f) }

      Dir.glob(globs).each do |node|
        components = node.sub(dirname, '').split(File::SEPARATOR)[2..-1]

        selected_components = select_components(datapath, components)

        # Select main datapath if allowed
        if selected_datapath = @project.allowed_paths.include?(datapath.path)
          projects_datapath = @project.projects_datapaths.select {|pd| pd.full_path == datapath.path}.first
          datapath_object = {projects_datapath: {id: projects_datapath.id, name: projects_datapath.name}}
        end

        next unless selected_or_manager = (selected_datapath || selected_components.any? || (can? :manage, @project))

        parent = add_node_to_tree(tree, datapath.path, selected_components.any?, datapath.id, selected_datapath, datapath_object)

        components.each_with_index do |component, index|
          expanded = selected_components.any? && selected_components.last.keys.first > index
          if selected = selected_components.select {|hash| hash.keys.include?(index)}.any?
            object = selected_components.select {|hash| hash[index]}.first.values.first
          end
          if parent
            next unless selected_or_manager
            parent = add_node_to_tree(parent, component, expanded, nil, selected, object)
          else
            next unless selected_or_manager
            parent = add_node_to_tree(tree, component, expanded, nil, selected, object)
          end
        end
      end
    end

    tree
  end

  def select_components(datapath, components)
    # Select allowed datapaths and tracks
    selected_components = []

    built_path = datapath.path
    components.each_with_index do |component, index|
      built_path = File.join built_path, component
      if @project.allowed_paths.include?(built_path)
        projects_datapath = @project.projects_datapaths.select {|pd| pd.full_path == built_path}.first
        selected_components << { index => { projects_datapath: { id: projects_datapath.id, name: projects_datapath.name }}}
      elsif @project.tracks.collect {|t| t.full_path}.include?(built_path)
        track = @project.tracks.select {|t| t.full_path == built_path}.first
        selected_components << { index => { track: { id: track.id, name: track.name, igv: view_context.link_to_igv(track) }}}
      end
    end

    selected_components
  end

  def add_node_to_tree(tree, child, expanded=false, id=nil, selected=false, object=nil)
    if tree.is_a? Array
      parent = tree
    else
      tree[:children] = [] unless tree[:children]
      parent = tree[:children]
    end

    node = parent.select{|c| c[:title] == child}

    if node.empty?
      started_empty = true
      node = {title: child}
      node.merge!(key: id) if id
    else
      started_empty = false
      node = node.first
    end

    node.merge!(expanded: true) if expanded
    unless node[:title].include?('.')
      node.merge!(hideCheckbox: true) if cannot? :manage, @project
      node.merge!(folder: true)
    end
    if selected
      node.merge!(selected: true)
      node.merge!(object: object)
      if track = object[:track]
        node.merge!(hideCheckbox: true) if cannot? :destroy, Track.find(track[:id])
      end
    end

    parent << node if started_empty

    node
  end
end
