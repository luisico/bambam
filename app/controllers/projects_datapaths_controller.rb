class ProjectsDatapathsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json, only: [:browser]
  respond_to :js, only: [:create, :destroy]

  def create
    ProjectsDatapath.create(
      project_id: projects_datapath_params[:project_id],
      datapath_id: projects_datapath_params[:datapath_id]
    )
  end

  def destroy
    ProjectsDatapath.where(
      project_id: params[:id],
      datapath_id: projects_datapath_params[:datapath_id]
    ).first.destroy
  end

  def browser
    @project = Project.find(params[:id])
    tree = generate_tree Datapath.all
    respond_with tree.map {|hash| { title: hash[:title], key: hash[:key], selected: hash[:selected]}}
  end

  private

  def projects_datapath_params
    params.require(:projects_datapath).permit(:project_id, :datapath_id, :sub_directory, :name)
  end

  def generate_tree(datapaths=[])
    formats = %w(.bw .bam)
    tree = []

    datapaths.each do |datapath|
      common = File.dirname(datapath.path)
      globs = formats.map{ |f| File.join(datapath.path, "**", "*#{f}") }

      files = Dir.glob(globs)
      if files.empty?
        parent = add_node_to_tree(tree, datapath.path)
        parent[:folder] = true
        parent[:key] = datapath.id
        parent[:selected] = true if @project.datapaths.include? datapath
      else
        files.each do |file|
          parent = add_node_to_tree(tree, datapath.path, true, datapath.id)
          file.sub!(common, '').split(File::SEPARATOR)[2..-1].each do |item|
            parent = add_node_to_tree(parent, item)
          end
        end
      end
    end

    tree
  end

  def add_node_to_tree(tree, child, expanded=false, id=nil)
    if tree.is_a? Array
      parent = tree
    else
      tree[:children] = [] unless tree[:children]
      parent = tree[:children]
    end

    node = parent.select{|c| c[:title] == child}

    if node.empty?
      node = {title: child}
      if id
        node.merge!(key: id)
        node.merge!(selected: true) if @project.datapaths.include? Datapath.find(id)
      end
      node.merge!(expanded: true) if expanded

      tree[:folder] = true unless tree.is_a? Array
      parent << node
    else
      node = node.first
    end

    node
  end
end
