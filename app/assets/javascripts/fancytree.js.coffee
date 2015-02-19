class @Fancytree
  project_id = $('#track-tree').data('project')

  @applyFancytree: ->
    $('#track-tree').fancytree {
      source:
        url: "/projects_datapaths/browser?id=" + project_id
      checkbox: true
      extensions: ["table"]
      clickFolderMode: 2
      table: {
        checkboxColumnIdx: 0 # render the checkboxes into the this column index (default: nodeColumnIdx)
        nodeColumnIdx: 1     # render node expander, icon, and title to this column (default: #0)
      }
      select: (event, data) ->
        if data.node.folder
          attr = Fancytree.buildPath(event, data)
          if data.node.selected
            Fancytree.addPath(event, data, attr[0], attr[1])
          else
            Fancytree.deletePath(event, data, attr[0], attr[1])
        else
          attr = Fancytree.buildTrack(event, data)
          console.log(attr)
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

  @buildTrack: (event, data) ->
    parent_list = data.node.getParentList()
    dir_array = []
    projects_datapaths = []
    for i of parent_list
      dir_array.push(parent_list[i].title)
      if parent_list[i].data.object_id
        projects_datapaths.push([i, parent_list[i].data.object_id.projects_datapath_id])
    dir_array.push(data.node.title)
    track_array = dir_array.slice(Number(projects_datapaths[projects_datapaths.length-1][0])+1)
    path = track_array.join('/')
    name = track_array[track_array.length-1]
    projects_datapath_id = projects_datapaths[projects_datapaths.length-1][1]
    [path, name, projects_datapath_id]

  @addPath: (event, data, datapath_id, sub_dir) ->
    node = data.node
    $.ajax({
      type: "POST",
      url: "/projects_datapaths",
      data: { projects_datapath: { datapath_id: datapath_id, project_id: project_id, sub_directory: sub_dir } },
      success:(jqXHR, textStatus, errorThrown) ->
        node.data['object_id'] = { projects_datapath_id: jqXHR['projects_datapath_id']}
        $span = $(node.span)
        $span.effect("highlight", {}, 1500)
        return false
      error:(jqXHR, textStatus, errorThrown) ->
        $span = $(node.span)
        $span.addClass('error-red')
        $span.parents('tr').removeClass('fancytree-selected')
        $span.find('.fancytree-title').append(' [' + errorThrown.trim() + ']')
        return false
    })

  @deletePath: (event, data, datapath_id, sub_dir) ->
    node = data.node
    $.ajax({
      type: "POST",
      url: "/projects_datapaths/" + node.data.object_id.projects_datapath_id
      data: { _method: "delete" },
      success:(jqXHR, textStatus, errorThrown) ->
        $span = $(node.span)
        $span.effect("highlight", {}, 1500)
        return false
      error:(jqXHR, textStatus, errorThrown) ->
        $span = $(node.span)
        $span.addClass('error-red')
        $span.find('.fancytree-title').append(' [' + errorThrown.trim() + ']')
        return false
    })
