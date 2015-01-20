class @Fancytree
  @applyFancytree: ->
    project_id = $('#track-tree').data('project')
    $('#track-tree').fancytree {
    source:
      url: "/projects_datapaths/browser?id=" + project_id
    checkbox: true
    selectMode: 2
    select: (event, data) ->
      node = data.node
      console.log(node)
      $.ajax({
        type: "POST",
        url: "/projects_datapaths",
        data: { projects_datapath: { datapath_id: node.key, project_id: project_id } },
        success:(data) ->
          alert node.key
          return false
        error:(data) ->
          return false
      })
    }

