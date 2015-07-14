#= require filebrowser/filebrowser_node

class @Filebrowser
  constructor: (selector) ->
    @tree = $(selector)
    @project_id = @tree.data('project')
    @load()

  load: ->
    project_id = @project_id
    url = RAILS_RELATIVE_URL_ROOT + "/projects_datapaths/browser"

    @tree.fancytree
      source:
        url: url
        data:
          project: @project_id
      checkbox: true
      extensions: ["table"]
      clickFolderMode: 2
      table:
        checkboxColumnIdx: 0 # render the checkboxes into the this column index (default: nodeColumnIdx)
        nodeColumnIdx: 1     # render node expander, icon, and title to this column (default: #0)

      renderColumns: (event, data) ->
        node = data.node
        Filebrowser.node(node).renderColumns(node)

      lazyLoad: (event, data) ->
        node = new FilebrowserNode(data.node)
        data.result = {
          url: url
          data:
            project: project_id
            mode: "children"
            path: node.fullpath()
        }

      postProcess: (event, data) ->
        # Node triggering lazyLoad
        node = Filebrowser.node(data.node)

        # Hide checkboxes for non-selectable, non-folder nodes
        if !node.isSelectable()
          child.hideCheckbox = true for child in data.response when !child.folder

      click: (event, data) ->
        console.log(data)
        console.log(event)
        node = Filebrowser.node(data.node)
        console.log(node)
        console.log(node.isSelectable())

  @node: (node) ->
    # Instantiates a new FilebrowserNode
    if node.isFolder()
      new FilebrowserFolderNode(node)
    else
      new FilebrowserFileNode(node)
