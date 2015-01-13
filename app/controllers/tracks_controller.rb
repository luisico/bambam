class TracksController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource except: [:browser, :new, :create]
  # authorize_resource only: [:new, :create]

  respond_to :html, only: [:index, :show]
  respond_to :json, only: [:browser]


  def index
  end

  def show
  end

  def new
    @project = Project.find(params[:project_id])
  end

  def create
    raise params.inspect
  end

  def browser
    tree = generate_tree unique_paths(ENV['ALLOWED_TRACK_PATHS'])
    respond_with tree
  end

  private

  def track_params
    params.require(:track).permit(:name, :path, :project_id)
  end

  def unique_paths(paths=[])
    paths.split(':').map{|p| File.absolute_path(p)}.uniq
  end

  def generate_tree(paths=[])
    @key = 0
    formats = %w(.bw .bam)
    tree = []

    paths.each do |path|
      common = File.dirname(path)
      globs = formats.map{ |f| File.join(path, "**", "*#{f}") }

      files = Dir.glob(globs)
      if files.empty?
        parent = add_node_to_tree(tree, path)
        parent[:folder] = true
      else
        files.each do |file|
          parent = add_node_to_tree(tree, path, true)
          file.sub!(common, '').split(File::SEPARATOR)[2..-1].each do |item|
            parent = add_node_to_tree(parent, item)
          end
        end
      end
    end

    tree
  end

  def add_node_to_tree(tree, child, expanded=false)
    if tree.is_a? Array
      parent = tree
    else
      tree[:children] = [] unless tree[:children]
      parent = tree[:children]
    end

    node = parent.select{|c| c[:title] == child}

    if node.empty?
      node = {title: child, key: @key+=1}
      node.merge!(expanded: true) if expanded
      tree[:folder] = true unless tree.is_a? Array
      parent << node
    else
      node = node.first
    end

    node
  end
end
