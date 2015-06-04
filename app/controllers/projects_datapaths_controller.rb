class ProjectsDatapathsController < ApplicationController
  before_action :authenticate_user!
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
        # TOOD: sub only from beginning of string
        components = node.sub(dirname, '').split(File::SEPARATOR)[2..-1]

        selected_components = select_components(datapath, components)

        # Select main datapath if allowed
        # TODO: database select?
        if @project.allowed_paths.include?(datapath.path)
          datapath_object = @project.projects_datapaths.select{ |pd| pd.full_path == datapath.path }.first
        end

        next unless !datapath_object.nil? || !selected_components.empty? || (can? :manage, @project)

        # Skip unselected tracks for read only users
        next if !can?(:update_tracks, @project) && node.match(/\.(bam|bw)$/) && !selected_components.any?{|i,c| c.is_a?(Track)}

        # Add first component for tree
        parent = add_node_to_tree(tree, datapath.path, selected_components.any?, datapath.id, datapath_object)

        # Add components to tree. marking them as expanded and/or selected
        components.each_with_index do |component, index|
          expanded = !selected_components.empty? && selected_components.to_a.last.first > index
          object = selected_components[index]
          parent = add_node_to_tree(parent ? parent : tree, component, expanded, nil, object, selected_components.empty? && datapath_object.nil?)
        end
      end
    end

    tree
  end

  def select_components(datapath, components)
    # Select allowed datapaths and tracks
    selected_components = {}

    built_path = datapath.path
    components.each_with_index do |component, index|
      built_path = File.join built_path, component
      if @project.allowed_paths.include?(built_path)
        projects_datapath = @project.projects_datapaths.where(datapath: datapath, sub_directory: built_path.sub("#{datapath.path}/", '')).first
        selected_components[index] = projects_datapath
      elsif @project.tracks.collect {|t| t.full_path}.include?(built_path)
        # TODO: database select?
        track = @project.tracks.select {|t| t.full_path == built_path}.first
        selected_components[index] = track
      end
    end

    selected_components
  end

  def add_node_to_tree(tree, child, expanded=false, id=nil, object=nil, selected_components_empty=true)
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

    if node[:title].match(/\.(bam|bw)$/)
      node.merge!(hideCheckbox: true) if selected_components_empty
    else
      node.merge!(hideCheckbox: true) if cannot? :manage, @project
      node.merge!(folder: true)
    end

    if object
      node.merge!(selected: true)
      object_properties = {id: object.id, name: object.name}
      object_properties.merge!(genome: object.genome, igv: view_context.link_to_igv(object)) if object.is_a?(Track)
      node.merge!(object: {object.class.to_s.underscore.to_sym => object_properties})
      if object.is_a?(Track)
        node.merge!(hideCheckbox: true) if cannot? :update, object
      end
    end

    parent << node if started_empty

    node
  end
end
