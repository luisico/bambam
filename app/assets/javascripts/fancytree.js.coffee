class @Fancytree
  project_id = $('#track-tree').data('project')

  @applyFancytree: ->
    $('#track-tree').fancytree {
      source:
        url: RAILS_RELATIVE_URL_ROOT + "/projects_datapaths/browser?id=" + project_id
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
        $tdList.eq(1).attr('title', node.title)
        if node.folder and node.selected
          $tdList.eq(2).addClass('projects-datapath-name').html(node.data.object.projects_datapath.name)
          $tdList.eq(2).attr('title', node.data.object.projects_datapath.name)
        else if node.folder
          $tdList.eq(2).addClass('projects-datapath-name')
        else if node.selected
          $tdList.eq(2).addClass('track-link').html("<a href='" + RAILS_RELATIVE_URL_ROOT + "/tracks/" + node.data.object.track.id + "'>" + node.data.object.track.name + "</a>").attr('title', node.data.object.track.name)
          $tdList.eq(3).addClass('track-genome').html("<span class='label genome'>" + node.data.object.track.genome + "</span>")
          $tdList.eq(4).addClass('track-igv').html(node.data.object.track.igv)
        else
          $tdList.eq(2).addClass('track-link')
          $tdList.eq(3).addClass('track-genome')
          $tdList.eq(4).addClass('track-igv')

      beforeSelect: (event, data) ->
        if data.node.selected and data.node.folder
          selectedParent = Fancytree.selectedParent(data.node)
          children = Fancytree.deepChildrenList(data.node, [])
          selectedChildFolders = Fancytree.selectedChildFolders(children)
          selectedChildTracks = Fancytree.selectedChildTracks(children)
          if selectedParent == undefined and selectedChildFolders.length == 0 and selectedChildTracks.length > 0
            if confirm("Deselecting this folder will permanently delete all child tracks. Are you sure you want to continue?")
              for i of selectedChildTracks
                selectedChildTracks[i].toggleSelected()
              true
            else
              false
        else if data.node.folder
          selectedSiblingTracks = Fancytree.siblingTracks(data.node).filter((x) -> x.selected == true)
          array = []
          parentList = data.node.getParentList()
          for i of parentList
            siblingTracks = Fancytree.siblingTracks(parentList[i]).filter((x) -> x.selected == true)
            array.push(siblingTracks)
          selectedSiblingTracksOfParents = [].concat.apply([],array)
          selectedSiblingTracks = selectedSiblingTracks.concat(selectedSiblingTracksOfParents)
          if selectedSiblingTracks.length > 0
            if confirm("Selecting this folder will permanently delete all sibling tracks. Are you sure you want to continue?")
              for i of selectedSiblingTracks
                selectedSiblingTracks[i].toggleSelected()
                Fancytree.resetTrackCheckboxes([selectedSiblingTracks[i]], true)
              true
            else
              false

      select: (event, data) ->
        if data.node.folder
          attr = Fancytree.buildPath(data.node)
          if data.node.selected
            Fancytree.addPath(data.node, attr[0], attr[1], attr[2])
          else
            Fancytree.deletePath(data.node, attr[0], attr[1])
        else
          attr = Fancytree.buildTrack(data.node)
          if data.node.selected
            Fancytree.addTrack(data.node, attr[0], attr[1], attr[2])
          else
            Fancytree.deleteTrack(data.node)
    }

  @buildPath: (node) ->
    parent_list = node.getParentList()
    if parent_list.length > 0
      datapath_id = parent_list[0].key
      dir_array = []
      for i of parent_list
        dir_array.push(parent_list[i].title)
      sub_array = dir_array.slice(1)
      sub_array.push(node.title)
      path = sub_array.join('/')
      name = sub_array.pop()
    else
      datapath_id = node.key
      path = ""
      name = node.title.split('/').pop()
    [datapath_id, path, name]

  @buildTrack: (node, isTransitionTrack) ->
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

  @addPath: (node, datapath_id, path, name) ->
    $.ajax({
      type: "POST",
      dataType: "json",
      url: RAILS_RELATIVE_URL_ROOT + "/projects_datapaths",
      data: { projects_datapath: { datapath_id: datapath_id, project_id: project_id, path: path, name: name } },
      success:(jqXHR, textStatus, errorThrown) ->
        Fancytree.resetPathHierarchy(node, jqXHR.projects_datapath.id)
        node.data['object'] = jqXHR
        $tr = $(node.tr)
        $tr.find('.projects-datapath-name').html(jqXHR.projects_datapath.name).attr('title', node.data.object.projects_datapath.name)
        $tr.effect("highlight", {}, 1500)
        return false
      error:(jqXHR, textStatus, errorThrown) ->
        if jqXHR.responseJSON
          errorMessage = jqXHR.responseJSON.message
        else
          errorMessage = errorThrown
        $tr = $(node.tr)
        $tr.addClass('error-red')
        $tr.removeClass('fancytree-selected')
        $tr.find('.fancytree-title').append(' [' + errorMessage + ']')
        return false
    })

  @deletePath: (node, datapath_id, path) ->
    children = Fancytree.deepChildrenList(node, [])
    if Fancytree.selectedParent(node) == undefined and Fancytree.selectedChildFolders(children).length == 0
      Fancytree.resetTrackCheckboxes(Fancytree.childTracks(node), true)
    $.ajax({
      type: "POST",
      dataType: "json",
      url: RAILS_RELATIVE_URL_ROOT + "/projects_datapaths/" + node.data.object.projects_datapath.id
      data: { _method: "delete" },
      success:(jqXHR, textStatus, errorThrown) ->
        $tr = $(node.tr)
        $tr.find('.projects-datapath-name').html('').attr('title', '')
        if $tr.is(':visible')
          $tr.effect("highlight", {}, 1500)
        delete node.data.object.projects_datapath
        return false
      error:(jqXHR, textStatus, errorThrown) ->
        if jqXHR.responseJSON
          errorMessage = jqXHR.responseJSON.message
        else
          errorMessage = errorThrown
        $tr = $(node.tr)
        $tr.addClass('error-red')
        $tr.find('.fancytree-title').append(' [' + errorMessage + ']')
        return false
    })

  @resetPathHierarchy: (node, projects_datapath_id) ->
    selectedParent = Fancytree.selectedParent(node)
    children = Fancytree.deepChildrenList(node, [])
    selectedChildFolders = Fancytree.selectedChildFolders(children)
    selectedChildTracks = Fancytree.selectedChildTracks(children)
    if selectedParent
      Fancytree.resolveOrphanTracks(selectedParent, selectedChildTracks)
      selectedParent.toggleSelected()
      Fancytree.transitionChildTracks(projects_datapath_id, selectedChildTracks)
      siblings = Fancytree.siblingFolders(node).concat(Fancytree.siblingTracks(node))
      for i of siblings
        if siblings[i].folder == true && siblings[i].selected != true
          siblingChildren = Fancytree.deepChildrenList(siblings[i], [])
          if Fancytree.selectedChildFolders(siblingChildren).length == 0
            Fancytree.resetTrackCheckboxes(Fancytree.childTracks(siblings[i]), true)
        else if siblings[i].folder != true
          Fancytree.resetTrackCheckboxes([siblings[i]], true)
      parentNodes =  node.getParentList()
      for i of parentNodes
        Fancytree.resetTrackCheckboxes(Fancytree.siblingTracks(parentNodes[i]), true)
    else if selectedChildFolders.length > 0
      for i of selectedChildFolders
        selectedChildFolders[i].toggleSelected()
        childTracks = Fancytree.childTracks(selectedChildFolders[i])
        Fancytree.transitionChildTracks(projects_datapath_id, childTracks.filter((x) -> x.selected))
      Fancytree.resetTrackCheckboxes(children.filter((x) -> x.folder != true), false)
    else if selectedChildTracks.length > 0
      Fancytree.transitionChildTracks(projects_datapath_id, selectedChildTracks)
    else
      childTracks = Fancytree.childTracks(node)
      Fancytree.resetTrackCheckboxes(childTracks, false)

  @deepChildrenList: (node, array) ->
    node = node.getFirstChild()
    while node
      array.push(node)
      Fancytree.deepChildrenList(node, array)
      node = node.getNextSibling()
    array

  @addTrack: (node, path, name, projects_datapath_id) ->
    $.ajax({
      type: "POST",
      dataType: "json",
      url: RAILS_RELATIVE_URL_ROOT + "/tracks",
      data: { track: { name: name, path: path, projects_datapath_id: projects_datapath_id } },
      success:(jqXHR, textStatus, errorThrown) ->
        node.data['object'] = jqXHR
        $tr = $(node.tr)
        $tr.find('.track-link').html("<a href='" + RAILS_RELATIVE_URL_ROOT + "/tracks/" + jqXHR.track.id + "'>" + jqXHR.track.name + "</a>").attr('title', node.data.object.track.name)
        $tr.find('.track-genome').html("<span class='label genome'>" + jqXHR.track.genome + "</span>")
        $tr.find('.track-igv').html(jqXHR.track.igv)
        $tr.effect("highlight", {}, 1500)
        Project.updateTracksCount()
        return false
      error:(jqXHR, textStatus, errorThrown) ->
        if jqXHR.responseJSON
          errorMessage = jqXHR.responseJSON.message
        else
          errorMessage = errorThrown
        $tr = $(node.tr)
        $tr.addClass('error-red').removeClass('fancytree-selected')
        $tr.find('.fancytree-title').append(' [' + errorMessage + ']')
        return false
    })

  @deleteTrack: (node) ->
    $.ajax({
      type: "POST",
      dataType: "json",
      url: RAILS_RELATIVE_URL_ROOT + "/tracks/" + node.data.object.track.id
      data: { _method: "delete" },
      success:(jqXHR, textStatus, errorThrown) ->
        $tr = $(node.tr)
        $tr.find('.track-link').html('').attr('title', '')
        $tr.find('.track-genome').html('')
        $tr.find('.track-igv').html("")
        if $tr.is(':visible')
          $tr.effect("highlight", {}, 1500)
        Project.updateTracksCount()
        return false
      error:(jqXHR, textStatus, errorThrown) ->
        if jqXHR.responseJSON
          errorMessage = jqXHR.responseJSON.message
        else
          errorMessage = errorThrown
        $tr = $(node.tr)
        $tr.addClass('error-red')
        $tr.find('.fancytree-title').append(' [' + errorMessage + ']')
        return false
    })

  @transitionChildTracks: (projects_datapath_id, childTracks) ->
    for i of childTracks
      track_id = childTracks[i].data.object.track.id
      path = Fancytree.buildTrack(childTracks[i], "isTransitionTrack")[0]
      Fancytree.updateTrack(childTracks[i], track_id, path, projects_datapath_id)

  @updateTrack: (node, track_id, path, projects_datapath_id) ->
    $.ajax({
      data: { track: { projects_datapath_id: projects_datapath_id, path: path } },
      type: 'PATCH',
      dataType: "json",
      url: RAILS_RELATIVE_URL_ROOT + '/tracks/' + track_id
      success:(jqXHR, textStatus, errorThrown) ->
        $tr = $(node.tr)
        if $tr.is(':visible')
          $tr.effect("highlight", {}, 1500)
        return false
      error:(jqXHR, textStatus, errorThrown) ->
        if jqXHR.responseJSON
          errorMessage = jqXHR.responseJSON.message
        else
          errorMessage = errorThrown
        $tr = $(node.tr)
        $tr.addClass('error-red')
        $tr.find('.fancytree-title').append(' [' + errorMessage + ']')
        return false
    });

  @resetTrackCheckboxes: (tracks, remove) ->
    for i of tracks
      tr = $(tracks[i].tr)
      if remove
        tracks[i].hideCheckbox = true
        tr.find('td span').first().removeClass('fancytree-checkbox')
      else
        tracks[i].hideCheckbox = false
        tr.find('td').first().html("<span class='fancytree-checkbox'></span>")

  @resolveOrphanTracks: (selectedParent, childTracks) ->
    selectedParentChildren = Fancytree.deepChildrenList(selectedParent, [])
    selectedParentChildTracks = Fancytree.selectedChildTracks(selectedParentChildren)
    orpanTracks = $(selectedParentChildTracks).not(childTracks).get()
    newProjectsDatapaths = []
    for i of orpanTracks
      orphanTrackParentList = orpanTracks[i].getParentList()
      newProjectsDatapaths.push(orphanTrackParentList[orphanTrackParentList.length - 1])
    uniqueNewProjectsDatapaths = newProjectsDatapaths.filter((elem, pos) -> newProjectsDatapaths.indexOf(elem) == pos)
    for i of uniqueNewProjectsDatapaths
      parents = uniqueNewProjectsDatapaths[i].getParentList()
      overlap = parents.filter((n) -> uniqueNewProjectsDatapaths.indexOf(n) != -1)
      unless overlap.length > 0
        uniqueNewProjectsDatapaths[i].toggleSelected()

  @childTracks: (node) ->
    Fancytree.deepChildrenList(node, []).filter((x) -> x.folder != true)

  @selectedChildTracks: (children) ->
    children.filter((x) -> x.selected == true and x.folder != true)

  @selectedChildFolders: (children) ->
    children.filter((x) -> x.selected == true and x.folder == true)

  @siblingTracks: (node) ->
    node.getParent().children.filter((x) -> x.folder != true)

  @siblingFolders: (node) ->
    node.getParent().children.filter((x) -> x.folder == true)

  @selectedParent: (node) ->
    node.getParentList().filter((x) -> x.folder and x.selected)[0]
