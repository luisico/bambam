class @Fancytree
  @applyFancytree: ->
    project_id = $('#track-tree').data('project')
    $('#track-tree').fancytree {
    source:
      url: "/tracks/browser?id=" + project_id
    checkbox: true
    selectMode: 2
    select: (event, data) ->
      node = data.node
      console.log(node)
      $.ajax({
        type: "POST",
        url: "/tracks?id=" + project_id,
        data: { track: { datapath_id: node.key } },
        success:(data) ->
          alert node.key
          return false
        error:(data) ->
          return false
      })
    }

