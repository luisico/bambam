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
      beforeSelect: (event, data) ->
        if data.node.selected and data.node.folder
          selectedParents = data.node.getParentList().filter((x) -> x.selected == true)
          selectedChildFolders = Fancytree.deepChildrenList(data.node, []).filter((x) -> x.selected == true and x.folder == true)
          selectedChildTracks = Fancytree.deepChildrenList(data.node, []).filter((x) -> x.selected == true and x.folder != true)
          if selectedParents.length == 0 and selectedChildFolders.length == 0 and selectedChildTracks.length > 0
            if confirm("Deselecting this folder will permanently delete all child tracks. Are you sure you want to continue?")
              for i of selectedChildTracks
                selectedChildTracks[i].toggleSelected()
              true
            else
              false
      select: (event, data) ->
        if data.node.folder
          attr = Fancytree.buildPath(event, data.node)
          if data.node.selected
            Fancytree.addPath(event, data.node, attr[0], attr[1], attr[2])
          else
            Fancytree.deletePath(event, data.node, attr[0], attr[1])
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
        Fancytree.resetPathHierarchy(event, node, jqXHR.projects_datapath.id)
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
    if node.getParentList().filter((x) -> x.selected).length == 0 and Fancytree.deepChildrenList(node,[]).filter((x) -> x.folder and x.selected).length == 0
      Fancytree.resetTrackCheckboxes(event, node, true)
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

  @resetPathHierarchy: (event, node, projects_datapath_id) ->
    parents = node.getParentList()
    oldSelectedParent = parents.filter((x) -> x.folder and x.selected)[0]
    children = Fancytree.deepChildrenList(node, [])
    selectedChildFolders = children.filter((x) -> x.folder and x.selected)
    if oldSelectedParent
      childTracks = children.filter((x) -> x.folder != true and x.selected)
      Fancytree.resolveOrphanTracks(event, oldSelectedParent, childTracks)
      oldSelectedParent.toggleSelected()
      Fancytree.transitionChildTracks(event, projects_datapath_id, childTracks)
    else if selectedChildFolders.length > 0
      for i of selectedChildFolders
        selectedChildFolders[i].toggleSelected()
        childTracks = Fancytree.deepChildrenList(selectedChildFolders[i], []).filter((x) -> x.folder != true and x.selected)
        Fancytree.transitionChildTracks(event, projects_datapath_id, childTracks)
    else if children.filter((x) -> x.folder != true and x.selected).length > 0
      childTracks = children.filter((x) -> x.folder != true and x.selected)
      Fancytree.transitionChildTracks(event, projects_datapath_id, childTracks)
    else
      Fancytree.resetTrackCheckboxes(event, node, false)

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

  @transitionChildTracks: (event, projects_datapath_id, childTracks) ->
    for i of childTracks
      track_id = childTracks[i].data.object.track.id
      path = Fancytree.buildTrack(event, childTracks[i], "isTransitionTrack")[0]
      Fancytree.updateTrack(event, track_id, path, projects_datapath_id)

  @updateTrack: (event, track_id, path, projects_datapath_id) ->
    console.log([track_id, path, projects_datapath_id])
    $.ajax({
      data: { track: { projects_datapath_id: projects_datapath_id, path: path } },
      type: 'PATCH',
      dataType: "json",
      url: '/tracks/' + track_id
    });

  @resetTrackCheckboxes: (event, node, remove) ->
    childTracks = Fancytree.deepChildrenList(node,[]).filter((x) -> x.folder != true)
    if childTracks.length > 0
      for i of childTracks
        tr = $(childTracks[i].tr)
        if remove
          childTracks[i].hideCheckbox = true
          tr.find('td span').first().removeClass('fancytree-checkbox')
        else
          childTracks[i].hideCheckbox = false
          tr.find('td').first().html("<span class='fancytree-checkbox'></span>")

  @resolveOrphanTracks: (event, oldSelectedParent, childTracks) ->
    oldSelectedParentTracks = Fancytree.deepChildrenList(oldSelectedParent, []).filter((x) -> x.selected == true and x.folder != true)
    orpanTracks = $(oldSelectedParentTracks).not(childTracks).get()
    if orpanTracks.length > 0
      newProjectsDatapaths = []
      for i of orpanTracks
        newProjectsDatapaths.push(orpanTracks[i].getParentList()[1])
      uniqueNewProjectsDatapaths = newProjectsDatapaths.filter((elem, pos) -> newProjectsDatapaths.indexOf(elem) == pos)
      for i of uniqueNewProjectsDatapaths
        uniqueNewProjectsDatapaths[i].toggleSelected()
