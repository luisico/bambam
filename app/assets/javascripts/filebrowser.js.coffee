class @Filebrowser
  project_id = $('#track-tree').data('project')

  @load: ->
    $('#track-tree').fancytree
      source:
        url: "/projects_datapaths/browser"
        data:
          project: project_id
      lazyLoad: (event, data) ->
        node = data.node
        data.result = {
          url: "/projects_datapaths/browser"
          data:
            project: project_id
            mode: "children"
            path: Filebrowser.path(node)
        }
      click: (event, data) ->
        console.log(data)
        console.log(event)
        console.log(Filebrowser.path(data.node))

  @path: (node) ->
    $.map(node.getParentList(false, true), (val, i) ->
      val.title
    ).join("/")
