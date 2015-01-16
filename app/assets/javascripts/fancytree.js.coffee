class @Fancytree
  @applyFancytree: ->
    $('#track-tree').fancytree {
    source:
      url: "/tracks/browser?id=" + $('#track-tree').data('project')
    checkbox: true
    selectMode: 2
    select: (event, data) ->
      node = data.node
      console.log(node)
      $.ajax({
        type: "POST",
        url: "/tracks?id=" + $('#track-tree').data('project'),
        data: { track: { datapath_id: node.key } },
        success:(data) ->
          alert node.key
          return false
        error:(data) ->
          return false
      })
    }

