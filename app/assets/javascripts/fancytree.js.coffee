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
        if node.isFolder() and node.isSelected()
          $tdList.eq(2).addClass('projects-datapath-name').html(node.data.object.projects_datapath.name)
          $tdList.eq(2).attr('title', node.data.object.projects_datapath.name)
        else if node.isFolder()
          $tdList.eq(2).addClass('projects-datapath-name')
        else if node.isSelected()
          $tdList.eq(2).addClass('track-link').html("<a href='" + RAILS_RELATIVE_URL_ROOT + "/tracks/" + node.data.object.track.id + "'>" + node.data.object.track.name + "</a>").attr('title', node.data.object.track.name)
          $tdList.eq(3).addClass('track-genome').html("<span class='label genome'>" + node.data.object.track.genome + "</span>")
          $tdList.eq(4).addClass('track-igv').html(node.data.object.track.igv)
        else
          $tdList.eq(2).addClass('track-link')
          $tdList.eq(3).addClass('track-genome')
          $tdList.eq(4).addClass('track-igv')

      beforeSelect: (event, data) ->
        node = data.node
        if node.isFolder() and node.isSelected()
          selectedParent = Fancytree.selectedParent(node)
          selectedChildFolders = Fancytree.selectedChildFolders(node)
          selectedChildTracks = Fancytree.selectedChildTracks(node)
          if selectedParent == undefined and selectedChildFolders.length == 0 and selectedChildTracks.length > 0
            if confirm("Deselecting this folder will permanently delete all child tracks. Are you sure you want to continue?")
              for i of selectedChildTracks
                selectedChildTracks[i].toggleSelected()
              true
            else
              false
        else if node.isFolder()
          selectedSiblingTracks = Fancytree.selectedFilter(Fancytree.siblingTracks(node))
          array = []
          parentList = node.getParentList()
          for i of parentList
            siblingTracks = Fancytree.selectedFilter(Fancytree.siblingTracks(parentList[i]))
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
        node = data.node
        if node.isFolder()
          if node.isSelected() then Fancytree.addPath(node) else Fancytree.deletePath(node)
        else
          if node.isSelected() then Fancytree.addTrack(node) else Fancytree.deleteTrack(node)
    }

  @buildPath: (node) ->
    parents = node.getParentList(false, true)
    datapath_id = parents[0].key
    path = $.map(parents, (val, i) ->
      val.title
    ).slice(1).join('/')
    name = node.title.split('/').pop()
    [datapath_id, path, name]

  @buildTrack: (node) ->
    parents = node.getParentList(false, true)
    selected = $.grep(parents, (val, i) ->
      val.isSelected()
    )[0]
    projects_datapath_id = selected.data.object.projects_datapath.id if selected.data.object and selected.data.object.projects_datapath
    path = $.map(parents.slice($.inArray(selected, parents)+1), (val, i) ->
      val.title
    ).join('/')
    name = node.title.replace(/\.[^/.]+$/, "")
    [projects_datapath_id, path, name]

  @addPath: (node) ->
    [datapath_id, path, name] = Fancytree.buildPath(node)
    $.ajax
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

  @deletePath: (node) ->
    [datapath_id, path, name] = Fancytree.buildPath(node)
    if Fancytree.selectedParent(node) == undefined and Fancytree.selectedChildFolders(node).length == 0
      Fancytree.resetTrackCheckboxes(Fancytree.childTracks(node), true)
    $.ajax
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

  @resetPathHierarchy: (node, projects_datapath_id) ->
    selectedParent = Fancytree.selectedParent(node)
    selectedChildFolders = Fancytree.selectedChildFolders(node)
    selectedChildTracks = Fancytree.selectedChildTracks(node)
    if selectedParent
      Fancytree.resolveOrphanTracks(selectedParent, selectedChildTracks)
      selectedParent.toggleSelected()
      Fancytree.transitionChildTracks(projects_datapath_id, selectedChildTracks)
      siblings = Fancytree.siblingFolders(node).concat(Fancytree.siblingTracks(node))
      for i of siblings
        if siblings[i].isFolder() && !siblings[i].isSelected()
          if Fancytree.selectedChildFolders(siblings[i]).length == 0
            Fancytree.resetTrackCheckboxes(Fancytree.childTracks(siblings[i]), true)
        else if !siblings[i].isFolder()
          Fancytree.resetTrackCheckboxes([siblings[i]], true)
      parentNodes =  node.getParentList()
      for i of parentNodes
        Fancytree.resetTrackCheckboxes(Fancytree.siblingTracks(parentNodes[i]), true)
    else if selectedChildFolders.length > 0
      for i of selectedChildFolders
        selectedChildFolders[i].toggleSelected()
        childTracks = Fancytree.childTracks(selectedChildFolders[i])
        Fancytree.transitionChildTracks(projects_datapath_id, Fancytree.selectedFilter(childTracks))
      children = Fancytree.deepChildrenList(node)
      Fancytree.resetTrackCheckboxes(Fancytree.trackFilter(children), false)
    else if selectedChildTracks.length > 0
      Fancytree.transitionChildTracks(projects_datapath_id, selectedChildTracks)
    else
      childTracks = Fancytree.childTracks(node)
      Fancytree.resetTrackCheckboxes(childTracks, false)

  @deepChildrenList: (node, array = []) ->
    node = node.getFirstChild()
    while node
      array.push(node)
      Fancytree.deepChildrenList(node, array)
      node = node.getNextSibling()
    array

  @addTrack: (node) ->
    [projects_datapath_id, path, name] = Fancytree.buildTrack(node)
    $.ajax
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

  @deleteTrack: (node) ->
    $.ajax
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

  @transitionChildTracks: (projects_datapath_id, childTracks) ->
    for i of childTracks
      track_id = childTracks[i].data.object.track.id
      path = Fancytree.buildTrack(childTracks[i])[1]
      Fancytree.updateTrack(childTracks[i], track_id, path, projects_datapath_id)

  @updateTrack: (node, track_id, path, projects_datapath_id) ->
    $.ajax
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
    selectedParentChildTracks = Fancytree.selectedChildTracks(selectedParent)
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
    Fancytree.trackFilter(Fancytree.deepChildrenList(node))

  @selectedChildTracks: (node) ->
    Fancytree.selectedTrackFilter(Fancytree.deepChildrenList(node))

  @selectedChildFolders: (node) ->
    Fancytree.selectedFolderFilter(Fancytree.deepChildrenList(node))

  @siblingTracks: (node) ->
    Fancytree.trackFilter(node.getParent())

  @siblingFolders: (node) ->
    Fancytree.folderFilter(node.getParent())

  @selectedParent: (node) ->
    Fancytree.selectedFolderFilter(node.getParentList())[0]

  @folderFilter: (nodes) ->
    $.grep(nodes, (node) -> node.isFolder())

  @trackFilter: (nodes) ->
    $.grep(nodes, (node) -> !node.isFolder())

  @selectedFilter: (nodes) ->
    $.grep(nodes, (node) -> node.isSelected())

  @selectedFolderFilter: (nodes) ->
    $.grep(nodes, (node) -> node.isSelected() and node.isFolder())

  @selectedTrackFilter: (nodes) ->
    $.grep(nodes, (node) -> node.isSelected() and !node.isFolder())

