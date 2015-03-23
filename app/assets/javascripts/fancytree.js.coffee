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
      renderColumns: (event, data) ->
        node = data.node
        $tdList = $(node.tr).find(">td")
        if node.folder and node.selected
          $tdList.eq(2).text(node.data['object']['projects_datapath']['name'])
        else if node.selected
          $tdList.eq(2).addClass('track-name').text(node.data['object']['track']['name'])
          $tdList.eq(3).addClass('track-link').html("<a href='/tracks/" + node.data['object']['track']['id'] + "'>link</a>")
        else
          $tdList.eq(2).addClass('track-name')
          $tdList.eq(3).addClass('track-link')
      select: (event, data) ->
        if data.node.folder
          attr = Fancytree.buildPath(event, data)
          if data.node.selected
            Fancytree.addPath(event, data, attr[0], attr[1])
          else
            Fancytree.deletePath(event, data, attr[0], attr[1])
        else if data.node.getParentList().filter((x) -> x.selected == true).length == 0
          track_title = data.node.title
          $tr = $(data.node.tr)
          $tr.removeClass('fancytree-selected').effect('highlight', {color: 'red'}, 5000)
          $tr.find('.fancytree-title').append(' [must select at least 1 parent directory]')
          setTimeout (->
            $tr.find('.fancytree-title').text(track_title)
            return
          ), 5000
        else
          attr = Fancytree.buildTrack(event, data)
          if data.node.selected
            Fancytree.addTrack(event, data, attr[0], attr[1], attr[2])
          else
            Fancytree.deleteTrack(event, data)
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
      if parent_list[i].data.object
        projects_datapaths.push([i, parent_list[i].data.object.projects_datapath.id])
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
      dataType: "json",
      url: "/projects_datapaths",
      data: { projects_datapath: { datapath_id: datapath_id, project_id: project_id, sub_directory: sub_dir } },
      success:(jqXHR, textStatus, errorThrown) ->
        node.data['object'] = jqXHR
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
      dataType: "json",
      url: "/projects_datapaths/" + node.data.object.projects_datapath.id
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

  @addTrack: (event, data, path, name, projects_datapath_id) ->
    node = data.node
    $.ajax({
      type: "POST",
      dataType: "json",
      url: "/tracks",
      data: { track: { name: name, path: path, projects_datapath_id: projects_datapath_id } },
      success:(jqXHR, textStatus, errorThrown) ->
        node.data['object'] = jqXHR
        $tr = $(node.tr)
        $tr.find('.track-name').text(jqXHR.track.name)
        $tr.find('.track-link').html("<a href='/tracks/" + jqXHR.track.id + "'>link</a>")
        $tr.effect("highlight", {}, 1500)
        return false
      error:(jqXHR, textStatus, errorThrown) ->
        $tr = $(node.tr)
        $tr.addClass('error-red').removeClass('fancytree-selected')
        $tr.find('.fancytree-title').append(' [' + errorThrown.trim() + ']')
        return false
    })

  @deleteTrack: (event, data) ->
    node = data.node
    $.ajax({
      type: "POST",
      dataType: "json",
      url: "/tracks/" + node.data.object.track.id
      data: { _method: "delete" },
      success:(jqXHR, textStatus, errorThrown) ->
        $tr = $(node.tr)
        $tr.find('.track-name').text('')
        $tr.find('.track-link').html("")
        $tr.effect("highlight", {}, 1500)
        return false
      error:(jqXHR, textStatus, errorThrown) ->
        $tr = $(node.tr)
        $tr.addClass('error-red')
        $tr.find('.fancytree-title').append(' [' + errorThrown.trim() + ']')
        return false
    })
