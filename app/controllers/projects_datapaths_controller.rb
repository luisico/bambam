class ProjectsDatapathsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json, only: [:browser]
  respond_to :js, only: [:create, :destroy]

  def create
    @projects_datapath = ProjectsDatapath.new(projects_datapath_params)
    @projects_datapath.save
  end

  def destroy
    @projects_datapath = ProjectsDatapath.where(
      projects_datapath_params.merge(project_id: params[:id])
    ).first
    @projects_datapath.destroy
  end

  def browser
    @project = Project.find(params[:id])
    tree = generate_tree Datapath.all
    respond_with tree
  end

  private

  def projects_datapath_params
    params.require(:projects_datapath).permit(:project_id, :datapath_id, :sub_directory, :name)
  end

  def generate_tree(datapaths=[])
    tree = []

    datapaths.each do |datapath|
      common = File.dirname(datapath.path)
      directories = Dir.glob(File.join(datapath.path, "**/"))

      directories.each do |file|
        components = file.sub!(common, '').split(File::SEPARATOR)[2..-1]
        built_path = datapath.path
        selected_indexes = []

        components.each_with_index do |component, index|
          built_path = File.join built_path, component
          selected_indexes << index if @project.allowed_paths.include?(built_path)
        end

        parent = add_node_to_tree(tree, datapath.path, selected_indexes.any?, datapath.id, @project.allowed_paths.include?(datapath.path))

        components.each_with_index do |component, index|
          expanded = !selected_indexes.empty? && selected_indexes.last > index
          selected = selected_indexes.include?(index)
          parent = add_node_to_tree(parent, component, expanded, nil, selected)
        end
      end
    end

    tree
  end

  def add_node_to_tree(tree, child, expanded=false, id=nil, selected=false)
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

      parent << node
    else
      node = node.first
      node.merge!(expanded: true) if expanded
      node.merge!(selected: true) if selected
    end

    node.merge!(folder: true)
  end
end
