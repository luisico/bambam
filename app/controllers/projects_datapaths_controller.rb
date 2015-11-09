class ProjectsDatapathsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource

  respond_to :json

  def create
    @projects_datapath = ProjectsDatapath.new(projects_datapath_params)
    if @projects_datapath.save
      render json: {type: "projects_datapath", id: @projects_datapath.id, name: @projects_datapath.name}, status: 200
    else
      render json: {status: :error, message: error_messages(@projects_datapath, "Record not created")}, status: 400
    end
  end

  def destroy
    @projects_datapath = ProjectsDatapath.find_by_id(params[:id])
    if @projects_datapath && @projects_datapath.destroy
      render json: {status: :success, message: 'OK' }, status: 200
    else
      render json: {status: :error, message: error_messages(@projects_datapath, "Record not deleted")}, status: 400
    end
  end

  def browser
    tree = []
    status = 200

    if @project = Project.find(params[:project])
      if params[:mode] && params[:mode] == "children"
        if allowed_datapaths.any? {|datapath| params[:path].match datapath.path}
          tree = FilebrowserService.new(params[:path]).to_fancytree
          tree = checkbox_abilities tree, true
        else
          status = 403
        end
      else
        tree = top_level_tree
        tree = fill_in_tree tree
        tree = checkbox_abilities tree
      end

    else
      status = 422
    end

    respond_with tree, status: status
  end

  private

  def allowed_datapaths
    can?(:manage, @project) ? @project.owner.datapaths : @project.datapaths
  end

  def top_level_tree
    tree = []
    allowed_datapaths.each do |datapath|
      # Main project datapaths
      node = {title: datapath.path, folder: true, lazy: true}
      node[:object] = {datapath_id: datapath.id}
      tree << node

      # Selected projects_datapaths
      @project.projects_datapaths.where(datapath: datapath).each do |projects_datapath|
        node_attr = {type: 'projects_datapath', id: projects_datapath.id, name: projects_datapath.name}
        pd_node = projects_datapath.path.blank? ? node.merge!({selected: true, expanded: true}) : add_path(node, projects_datapath.path, false, datapath.path)
        pd_node[:object] ? pd_node[:object].merge!(node_attr) : pd_node[:object] = node_attr

        # Selected tracks
        projects_datapath.tracks.each do |track|
          track_node = add_path(pd_node, track.path, true, projects_datapath.full_path)
          track_node[:object] = {type: 'track', id: track.id, name: track.name, genome: track.genome, igv: view_context.link_to_igv(track)}
        end
      end
    end

    tree
  end

  def fill_in_tree(tree=[], root='')
    tree.each do |child|
      # Tracks at same level as top level datapath are not rendered in tree
      next unless child[:folder]
      next if child[:iconclass] == 'missing'

      # If top level datapath set path to title , else add child title to existing root
      path = root.blank? ? child[:title] : File.join(root, child[:title])

      # Recursively add all children to path
      child[:children] = fill_in_tree(child[:children], path) if child[:children]
      # Retrive directory structure from filesystem
      items = FilebrowserService.new(path).to_fancytree

      if !items.empty?
        # add unselected nodes to children of selected child node
        if child[:children]
          items.each do |item|
            unless item[:folder]
              # hide checkbox for silbing files on selected folders
              item.merge!(hideCheckbox: true) if child[:children].any? {|child| child[:folder] && child[:selected]}
            end
            # Begin process of adding item to node only if it wasn't already put there by top_level_tree)
            unless child[:children].any?{|child| child[:title] == item[:title]}
              if can? :manage, @project
                child[:children] << item
              else
                # don't show regular users folders not in top_level or sibling folders/files of checked folder
                child[:children] << item unless item[:folder] || child[:children].any? {|child| child[:folder] && child[:selected]}
              end
            end

          end
        else
          # add children to child node only if child is selected
          child[:children] = items if child[:selected]
        end
      end
    end

    tree
  end

  def add_path(parent, path, is_track=false, parent_path)
    raise ArgumentError if path.blank?

    head, tail = path.split(File::SEPARATOR, 2)
    full_path = [parent_path, head].join(File::SEPARATOR)

    # Create new node
    node = {title: head}
    node.merge!(folder: true, lazy: true) if (is_track && tail) || !is_track
    node.merge!(selected: true) unless tail
    node.merge!(expanded: true) unless is_track
    node.merge!(iconclass: 'missing') unless File.exist?(full_path)

    # Add node to parent if not already present
    parent[:expanded] = true
    parent[:children] ||= []
    if new_parent = parent[:children].select{|child| child[:title] == node[:title]}.first
      node = new_parent
    else
      parent[:children] << node
    end

    # Add rest of path recursively
    node = add_path(node, tail, is_track, full_path) if tail

    node
  end

  def checkbox_abilities(tree, selected_parent=false)
    tree.each do |child|
      if child[:folder]
        child.merge!(hideCheckbox: true) if cannot? :manage, @project
        selected_parent ||= child[:selected]
      elsif child[:selected]
        child.merge!(hideCheckbox: true) if cannot? :update, @project.tracks.find(child[:object][:id])
      else
        child.merge!(hideCheckbox: true) unless (selected_parent && can?(:update_tracks, @project))
      end
      checkbox_abilities(child[:children], selected_parent) if child[:children]
    end
  end

  def projects_datapath_params
    params.require(:projects_datapath).permit(:project_id, :datapath_id, :path, :name)
  end

  def error_messages(projects_datapath, default)
    errors = projects_datapath.errors.full_messages.join('; ')
    errors.empty? ? default : errors
  end
end
