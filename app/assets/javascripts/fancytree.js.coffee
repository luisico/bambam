class @Fancytree
  @applyFancytree: ->
    $('#track-tree').fancytree {
    source:
      url: "/tracks/browser"
    checkbox: true
    select: (event, data) ->
      node = data.node
      console.log(node.key)
      $.ajax({
        type: "POST",
        url: "/tracks?id=" + $('#project_id').val() ,
        data: { track: { datapath_id: node.key } },
        success:(data) ->
          alert node.key
          return false
        error:(data) ->
          return false
      })
    }

