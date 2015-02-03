class @Fancytree
  project_id = $('#track-tree').data('project')

  @applyFancytree: ->
    $('#track-tree').fancytree {
      source:
        url: "/projects_datapaths/browser?id=" + project_id
      checkbox: true
      selectMode: 2
      select: (event, data) ->
        attr = Fancytree.buildPath(event, data)
        if data.node.selected
          Fancytree.addNode(event, data, attr[0], attr[1])
        else
          Fancytree.deleteNode(event, data, attr[0], attr[1])
    }

  @buildPath: (event, data) ->
    parent_list = data.node.getParentList()
    if parent_list.length > 0
      datapath_id = parent_list[0].key
      dir_array = []
      for i of parent_list
        dir_array.push(parent_list[i].title)
      sub_array = dir_array.slice(1)
      sub_array.push(data.node.title)
      sub_dir = sub_array.join('/')
    else
      datapath_id = data.node.key
      sub_dir = ""
    [datapath_id, sub_dir]

  @addNode: (event, data, datapath_id, sub_dir) ->
    node = data.node
    $.ajax({
      type: "POST",
      url: "/projects_datapaths",
      data: { projects_datapath: { datapath_id: datapath_id, project_id: project_id, sub_directory: sub_dir } },
      success:(jqXHR, textStatus, errorThrown) ->
        console.log(jqXHR)
        console.log(textStatus)
        console.log(errorThrown)
        $span = $(node.span)
        $span.effect("highlight", {}, 1500)
        return false
      error:(jqXHR, textStatus, errorThrown) ->
        console.log(jqXHR)
        console.log(textStatus)
        console.log(errorThrown)
        $span = $(node.span)
        $span.addClass('error-red').removeClass('fancytree-selected')
        $span.find('.fancytree-title').append(' [' + errorThrown.trim() + ']')
        return false
    })

  @deleteNode: (event, data, datapath_id, sub_dir) ->
    $.ajax({
      type: "POST",
      url: "/projects_datapaths/" + project_id,
      data: { projects_datapath: { datapath_id: datapath_id, sub_directory: sub_dir }, _method: "delete" },
      success:(data) ->
        console.log(datapath_id)
        return false
      error:(data) ->
        return false
    })
