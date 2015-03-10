class ProjectsDatapathsController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource

  respond_to :json

  def create
    @projects_datapath = ProjectsDatapath.new(projects_datapath_params)
    if @projects_datapath.save
      render json: {projects_datapath_id: @projects_datapath.id}, status: 200
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
      common = File.dirname(datapath.path)
      globs = formats.map{ |f| File.join(datapath.path, "**", f) }

      nodes = Dir.glob(globs)
      nodes.each do |node|
        components = node.sub!(common, '').split(File::SEPARATOR)[2..-1]
        built_path = datapath.path
        selected_indexes = []

        components.each_with_index do |component, index|
          built_path = File.join built_path, component
          if @project.allowed_paths.include?(built_path)
            selected_indexes << { index => { projects_datapath_id: @project.projects_datapaths.select {|pd| pd.full_path == built_path}.first.id }}
          elsif @project.tracks.collect {|t| t.full_path}.include?(built_path)
            selected_indexes << { index => { track_id: @project.tracks.select {|t| t.full_path == built_path}.first.id }}
          end
        end

        if parent_selected = @project.allowed_paths.include?(datapath.path)
          parent_object_id = { projects_datapath_id: @project.projects_datapaths.select {|pd| pd.full_path == datapath.path}.first.id }
        end

        parent = add_node_to_tree(tree, datapath.path, selected_indexes.any?, datapath.id, parent_selected, parent_object_id)

        components.each_with_index do |component, index|
          expanded = selected_indexes.any? && selected_indexes.last.keys.first > index
          if selected = selected_indexes.select {|hash| hash.keys.include?(index)}.any?
            object_id = selected_indexes.select {|hash| hash[index]}.first.values.first
          end
          parent = add_node_to_tree(parent, component, expanded, nil, selected, object_id)
        end
      end
    end

    tree
  end

  def add_node_to_tree(tree, child, expanded=false, id=nil, selected=false, object_id=nil)
    if tree.is_a? Array
      parent = tree
    else
      tree[:children] = [] unless tree[:children]
      parent = tree[:children]
    end

    node = parent.select{|c| c[:title] == child}

    if node.empty?
      node = {title: child}
      node.merge!(key: id) if id
      node.merge!(expanded: true) if expanded
      node.merge!(selected: true) if selected
      node.merge!(object_id: object_id) if selected
      node.merge!(hideCheckbox: true) if cannot? :manage, @project
      node.except!(:hideCheckbox) if node[:title].include? ('.bam'||'.bw')

      parent << node
    else
      node = node.first
      node.merge!(expanded: true) if expanded
      node.merge!(selected: true) if selected
      node.merge!(object_id: object_id) if selected
      node.merge!(hideCheckbox: true) if cannot? :manage, @project
      node.except!(:hideCheckbox) if node[:title].include? ('.bam'||'.bw')
    end

    node.merge!(folder: true) unless node[:title].include? ('.bam'||'.bw')
    node
  end
end