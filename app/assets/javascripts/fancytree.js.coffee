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
      if node.selected
        $.ajax({
          type: "POST",
          url: "/projects_datapaths",
          data: { projects_datapath: { datapath_id: node.key, project_id: project_id } },
          success:(data) ->
            console.log(node.key)
            return false
          error:(data) ->
            return false
        })
      else
        $.ajax({
          type: "DELETE",
          url: "/projects_datapaths/" + project_id,
          data: { projects_datapath: { datapath_id: node.key } },
          success:(data) ->
            console.log(node.key)
            return false
          error:(data) ->
            return false
        })
    }

