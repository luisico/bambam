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

      lazyLoad: (event, data) ->
        node = new FilebrowserNode(data.node)
        data.result = {
          url: url
          data:
            project: project_id
            mode: "children"
            path: node.fullpath()
        }

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
