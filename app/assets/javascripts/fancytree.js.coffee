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
          $tdList.eq(2).addClass('projects-datapath-name').text(node.data.object.projects_datapath.name)
        else if node.folder
          $tdList.eq(2).addClass('projects-datapath-name')
        else if node.selected
          $tdList.eq(2).addClass('track-name').html("<a href='/tracks/" + node.data.object.track.id + "'>" + node.data.object.track.name + "</a>")
          $tdList.eq(3).addClass('track-link').html(node.data.object.track.igv)
        else
          $tdList.eq(2).addClass('track-name')
          $tdList.eq(3).addClass('track-link')
      select: (event, data) ->
        if data.node.folder
          attr = Fancytree.buildPath(event, data.node)
          if data.node.selected
            Fancytree.addPath(event, data.node, attr[0], attr[1], attr[2])
            Fancytree.resetPathHierarchy(event, data.node)
          else
            Fancytree.deletePath(event, data.node, attr[0], attr[1])
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
          attr = Fancytree.buildTrack(event, data.node)
          if data.node.selected
            Fancytree.addTrack(event, data.node, attr[0], attr[1], attr[2])
          else
            Fancytree.deleteTrack(event, data.node)
    }

  @buildPath: (event, node) ->
    parent_list = node.getParentList()
    if parent_list.length > 0
      datapath_id = parent_list[0].key
      dir_array = []
      for i of parent_list
        dir_array.push(parent_list[i].title)
      sub_array = dir_array.slice(1)
      sub_array.push(node.title)
      sub_dir = sub_array.join('/')
      name = sub_array.pop()
    else
      datapath_id = node.key
      sub_dir = ""
      name = node.title.split('/').pop()
    [datapath_id, sub_dir, name]

  @buildTrack: (event, node, isTransitionTrack) ->
    parent_list = node.getParentList()
    dir_array = []
    for i of parent_list
      dir_array.push(parent_list[i].title)
      if parent_list[i].selected
        if isTransitionTrack
        else
          projects_datapath_id = parent_list[i].data.object.projects_datapath.id
        projects_datapath_index = i
    dir_array.push(node.title)
    track_array = dir_array.slice(Number(projects_datapath_index)+1)
    path = track_array.join('/')
    name = track_array[track_array.length-1].replace(/\.[^/.]+$/, "")
    [path, name, projects_datapath_id]

  @addPath: (event, node, datapath_id, sub_dir, name) ->
    $.ajax({
      type: "POST",
      dataType: "json",
      url: "/projects_datapaths",
      data: { projects_datapath: { datapath_id: datapath_id, project_id: project_id, sub_directory: sub_dir, name: name } },
      success:(jqXHR, textStatus, errorThrown) ->
        node.data['object'] = jqXHR
        $tr = $(node.tr)
        $tr.find('.projects-datapath-name').text(jqXHR.projects_datapath.name)
        $tr.effect("highlight", {}, 1500)
        return false
      error:(jqXHR, textStatus, errorThrown) ->
        $tr = $(node.tr)
        $tr.addClass('error-red')
        $tr.removeClass('fancytree-selected')
        $tr.find('.fancytree-title').append(' [' + errorThrown.trim() + ']')
        return false
    })

  @deletePath: (event, node, datapath_id, sub_dir) ->
    $.ajax({
      type: "POST",
      dataType: "json",
      url: "/projects_datapaths/" + node.data.object.projects_datapath.id
      data: { _method: "delete" },
      success:(jqXHR, textStatus, errorThrown) ->
        $tr = $(node.tr)
        $tr.find('.projects-datapath-name').text('')
        $tr.effect("highlight", {}, 1500)
        delete node.data.object.projects_datapath
        return false
      error:(jqXHR, textStatus, errorThrown) ->
        $tr = $(node.tr)
        $tr.addClass('error-red')
        $tr.find('.fancytree-title').append(' [' + errorThrown.trim() + ']')
        return false
    })

  @resetPathHierarchy: (event, node) ->
    parents = node.getParentList()
    children = Fancytree.deepChildrenList(node, [])
    allNodes = parents.concat(children)
    for i of allNodes
      if allNodes[i].folder and allNodes[i].selected
        allNodes[i].toggleSelected()
    Fancytree.transitionChildTracks(event, children)

  @deepChildrenList: (node, array) ->
    node = node.getFirstChild()
    while node
      array.push(node)
      Fancytree.deepChildrenList(node, array)
      node = node.getNextSibling()
    array

  @addTrack: (event, node, path, name, projects_datapath_id) ->
    $.ajax({
      type: "POST",
      dataType: "json",
      url: "/tracks",
      data: { track: { name: name, path: path, projects_datapath_id: projects_datapath_id } },
      success:(jqXHR, textStatus, errorThrown) ->
        node.data['object'] = jqXHR
        $tr = $(node.tr)
        $tr.find('.track-name').html("<a href='/tracks/" + jqXHR.track.id + "'>" + jqXHR.track.name + "</a>")
        $tr.find('.track-link').html(jqXHR.track.igv)
        $tr.effect("highlight", {}, 1500)
        return false
      error:(jqXHR, textStatus, errorThrown) ->
        $tr = $(node.tr)
        $tr.addClass('error-red').removeClass('fancytree-selected')
        $tr.find('.fancytree-title').append(' [' + errorThrown.trim() + ']')
        return false
    })

  @deleteTrack: (event, node) ->
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

  @transitionChildTracks: (event, children) ->
    for i of children
      if children[i].folder != true and children[i].selected
        track_id = children[i].data.object.track.id
        path = Fancytree.buildTrack(event, children[i], "isTransitionTrack")[0]
        parents = children[i].getParentList()
        for i of parents
          if parents[i].selected
            console.log(parents[i])
            # parents[i].data.object.projects_datapath.id
        console.log(track_id)
        console.log(path)

  @updateTrack: (event, track_id, path, projects_datapath_id) ->
    console.log([track_id, path, projects_datapath_id])
