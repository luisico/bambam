#= require filebrowser/filebrowser_node

class @Filebrowser
  constructor: (selector) ->
    @tree = $(selector)
    @project_id = @tree.data('project')
    @load()

  load: ->
    project_id = @project_id
    filebrowser = this
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
        fsNode = Filebrowser.node(data.node, filebrowser)
        fsNode.renderColumns()

      lazyLoad: (event, data) ->
        fsNode = Filebrowser.node(data.node, filebrowser)
        data.result = {
          url: url
          data:
            project: project_id
            mode: "children"
            path: fsNode.fullpath()
        }

      postProcess: (event, data) ->
        # Node triggering lazyLoad
        fsNode = Filebrowser.node(data.node, filebrowser)

        # Hide checkboxes for non-selectable, non-folder nodes
        if !fsNode.isSelectable()
          child.hideCheckbox = true for child in data.response when !child.folder

      select: (event, data) ->
        fsNode = Filebrowser.node(data.node, filebrowser)
        if fsNode.isSelected() then fsNode.createNode() else fsNode.destroyNode()

      beforeSelect: (event, data) ->
        fsNode = Filebrowser.node(data.node, filebrowser)
        if fsNode instanceof FilebrowserFolderNode
          if fsNode.isSelected() then fsNode.confirmSelectedFolder() else fsNode.confirmUnselectedFolder()

      click: (event, data) ->
        fsNode = Filebrowser.node(data.node, filebrowser)
        # console.log("NODE CLICKED")
        # console.log(data)
        # console.log(event)
        # console.log(node)
        # console.log(node.isSelectable())
        # console.log("----------")

  @node: (node, filebrowser) ->
    # Instantiates a new FilebrowserNode
    if node.isFolder()
      new FilebrowserFolderNode(node, filebrowser)
    else
      new FilebrowserFileNode(node, filebrowser)
