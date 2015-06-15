class @Fancytree
  project_id = $('#track-tree').data('project')

  @applyFancytree: ->
    $('#track-tree').fancytree
      source:
        url: RAILS_RELATIVE_URL_ROOT + "/projects_datapaths/browser?id=" + project_id
      checkbox: true
      extensions: ["table"]
      clickFolderMode: 2
      table:
        checkboxColumnIdx: 0 # render the checkboxes into the this column index (default: nodeColumnIdx)
        nodeColumnIdx: 1     # render node expander, icon, and title to this column (default: #0)

      renderColumns: (event, data) ->
        node = data.node

        tdList = $(node.tr).find(">td")
        tdList.eq(1).attr('title', node.title)
        if node.isFolder()
          col2 = tdList.eq(2).addClass('projects-datapath-name')
          if node.isSelected()
            col2.html(node.data.object.projects_datapath.name).attr('title', node.data.object.projects_datapath.name)
        else
          col2 = tdList.eq(2).addClass('track-link')
          col3 = tdList.eq(3).addClass('track-genome')
          col4 = tdList.eq(4).addClass('track-igv')
          if node.isSelected()
            col2.html("<a href='" + RAILS_RELATIVE_URL_ROOT + "/tracks/" + node.data.object.track.id + "'>" + node.data.object.track.name + "</a>").attr('title', node.data.object.track.name)
            col3.html("<span class='label genome'>" + node.data.object.track.genome + "</span>")
            col4.html(node.data.object.track.igv)

      beforeSelect: (event, data) ->
        node = data.node
        if node.isFolder()
          if node.isSelected() then Fancytree.confirmSelectedFolder(node) else Fancytree.confirmUnselectedFolder(node)

      select: (event, data) ->
        node = data.node
        if node.isFolder()
          if node.isSelected() then Fancytree.createDatapath(node) else Fancytree.destroyDatapath(node)
        else
          if node.isSelected() then Fancytree.createTrack(node) else Fancytree.destroyTrack(node)

  @createDatapath: (node) ->
    [datapath_id, path, name] = Fancytree.buildDatapath(node)
    $.ajax
      type: "POST"
      dataType: "json"
      url: RAILS_RELATIVE_URL_ROOT + "/projects_datapaths"
      data: { projects_datapath: { datapath_id: datapath_id, project_id: project_id, path: path, name: name } }
      context: node
      success: (jqXHR, textStatus, errorThrown) ->
        Fancytree.resetDatapathHierarchy(node, jqXHR.projects_datapath.id)
        node.data['object'] = jqXHR
        $(node.tr).find('.projects-datapath-name').html(jqXHR.projects_datapath.name).attr('title', node.data.object.projects_datapath.name)
        Fancytree.ajaxSuccess(node)
      error: Fancytree.ajaxError

  @destroyDatapath: (node) ->
    [datapath_id, path, name] = Fancytree.buildDatapath(node)
    if Fancytree.selectedParent(node) == undefined and Fancytree.selectedChildFolders(node).length == 0
      Fancytree.resetTrackCheckboxes(Fancytree.childTracks(node), true)
    $.ajax
      type: "POST"
      dataType: "json"
      url: RAILS_RELATIVE_URL_ROOT + "/projects_datapaths/" + node.data.object.projects_datapath.id
      data: { _method: "delete" }
      context: node
      success: (jqXHR, textStatus, errorThrown) ->
        $(node.tr).find('.projects-datapath-name').html('').attr('title', '')
        delete node.data.object.projects_datapath
        Fancytree.ajaxSuccess(node)
      error: Fancytree.ajaxError

  @createTrack: (node) ->
    [projects_datapath_id, path, name] = Fancytree.buildTrack(node)
    $.ajax
      type: "POST"
      dataType: "json"
      url: RAILS_RELATIVE_URL_ROOT + "/tracks"
      data: { track: { name: name, path: path, projects_datapath_id: projects_datapath_id } }
      context: node
      success: (jqXHR, textStatus, errorThrown) ->
        node.data['object'] = jqXHR
        tr = $(node.tr)
        tr.find('.track-link').html("<a href='" + RAILS_RELATIVE_URL_ROOT + "/tracks/" + jqXHR.track.id + "'>" + jqXHR.track.name + "</a>").attr('title', node.data.object.track.name)
        tr.find('.track-genome').html("<span class='label genome'>" + jqXHR.track.genome + "</span>")
        tr.find('.track-igv').html(jqXHR.track.igv)
        Project.updateTracksCount()
        Fancytree.ajaxSuccess(node)
      error: Fancytree.ajaxError

  @destroyTrack: (node) ->
    $.ajax
      type: "POST"
      dataType: "json"
      url: RAILS_RELATIVE_URL_ROOT + "/tracks/" + node.data.object.track.id
      data: { _method: "delete" }
      context: node
      success: (jqXHR, textStatus, errorThrown) ->
        tr = $(node.tr)
        tr.find('.track-link').html('')
        tr.find('.track-genome').html('')
        tr.find('.track-igv').html('')
        Project.updateTracksCount()
        Fancytree.ajaxSuccess(node)
      error: Fancytree.ajaxError

  @updateTrack: (node, track_id, path, projects_datapath_id) ->
    $.ajax
      type: "PATCH"
      dataType: "json"
      url: RAILS_RELATIVE_URL_ROOT + '/tracks/' + track_id
      data: { track: { projects_datapath_id: projects_datapath_id, path: path } }
      context: node
      success: (jqXHR, textStatus, errorThrown) ->
        Fancytree.ajaxSuccess(node)
      error: Fancytree.ajaxError

  @ajaxSuccess: (node) ->
    tr = $(node.tr)
    tr.effect("highlight", {}, 1500) if tr.is(':visible')
    return false

  @ajaxError: (jqXHR, textStatus, errorThrown) ->
    errorMessage = if jqXHR.responseJSON then jqXHR.responseJSON.message else errorThrown
    tr = $(this.tr).addClass('error-red')
    tr.toggleClass('fancytree-selected')
    tr.find('.fancytree-title').append(' [' + errorMessage + ']')
    return false

  @buildDatapath: (node) ->
    parents = node.getParentList(false, true)
    datapath_id = parents[0].key
    path = $.map(parents, (val, i) -> val.title).slice(1).join('/')
    name = node.title.split('/').pop()
    [datapath_id, path, name]

  @buildTrack: (node) ->
    parents = node.getParentList(false, true)
    selected = $.grep(parents, (val, i) -> val.isSelected())[0]
    projects_datapath_id = selected.data.object.projects_datapath.id if selected.data.object and selected.data.object.projects_datapath
    path = $.map(parents.slice($.inArray(selected, parents)+1), (val, i) -> val.title).join('/')
    name = node.title.replace(/\.[^/.]+$/, "")
    [projects_datapath_id, path, name]

  @resetDatapathHierarchy: (node, projects_datapath_id) ->
    selectedParent = Fancytree.selectedParent(node)
    selectedChildFolders = Fancytree.selectedChildFolders(node)
    selectedChildTracks = Fancytree.selectedChildTracks(node)
    if selectedParent
      Fancytree.resolveOrphanTracks(selectedParent, selectedChildTracks)
      selectedParent.toggleSelected()
      Fancytree.transitionChildTracks(projects_datapath_id, selectedChildTracks)
      siblings = Fancytree.siblingFolders(node).concat(Fancytree.siblingTracks(node))
      for sibling in siblings
        if sibling.isFolder() && !sibling.isSelected() && Fancytree.selectedChildFolders(sibling).length == 0
          Fancytree.resetTrackCheckboxes(Fancytree.childTracks(sibling), true)
        else if !sibling.isFolder()
          Fancytree.resetTrackCheckboxes([sibling], true)
      parentNodes =  node.getParentList()
      Fancytree.resetTrackCheckboxes(Fancytree.siblingTracks(parent), true) for parent in parentNodes
    else if selectedChildFolders.length > 0
      for folder in selectedChildFolders
        folder.toggleSelected()
        childTracks = Fancytree.childTracks(folder)
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

  @transitionChildTracks: (projects_datapath_id, childTracks) ->
    for track in childTracks
      track_id = track.data.object.track.id
      path = Fancytree.buildTrack(track)[1]
      Fancytree.updateTrack(track, track_id, path, projects_datapath_id)

  @resetTrackCheckboxes: (tracks, remove) ->
    for track in tracks
      tr = $(track.tr)
      if remove
        track.hideCheckbox = true
        tr.find('td span').first().removeClass('fancytree-checkbox')
      else
        track.hideCheckbox = false
        tr.find('td').first().html("<span class='fancytree-checkbox'></span>")

  @resolveOrphanTracks: (selectedParent, childTracks) ->
    selectedParentChildTracks = Fancytree.selectedChildTracks(selectedParent)
    newProjectsDatapaths = []
    orphanTracks = $(selectedParentChildTracks).not(childTracks).get()
    for orphanTrack in orphanTracks
      orphanTrackParentList = orphanTrack.getParentList()
      newProjectsDatapaths.push(orphanTrackParentList[orphanTrackParentList.length - 1])
    uniqueNewProjectsDatapaths = newProjectsDatapaths.filter((elem, pos) -> newProjectsDatapaths.indexOf(elem) == pos)
    for datapath in uniqueNewProjectsDatapaths
      parents = datapath.getParentList()
      overlap = parents.filter((n) -> uniqueNewProjectsDatapaths.indexOf(n) != -1)
      datapath.toggleSelected() unless overlap.length > 0

  @confirmSelectedFolder: (node) ->
    selectedParent = Fancytree.selectedParent(node)
    selectedChildFolders = Fancytree.selectedChildFolders(node)
    selectedChildTracks = Fancytree.selectedChildTracks(node)
    if selectedParent == undefined and selectedChildFolders.length == 0 and selectedChildTracks.length > 0
      if confirm("Deselecting this folder will permanently delete all child tracks. Are you sure you want to continue?")
        track.toggleSelected() for track in selectedChildTracks
        true
      else
        false

  @confirmUnselectedFolder: (node) ->
    selectedSiblingTracks = Fancytree.selectedFilter(Fancytree.siblingTracks(node))
    array = []
    array.push(Fancytree.selectedFilter(Fancytree.siblingTracks(parent))) for parent in node.getParentList()
    selectedSiblingTracksOfParents = [].concat.apply([], array)
    selectedSiblingTracks = selectedSiblingTracks.concat(selectedSiblingTracksOfParents)
    if selectedSiblingTracks.length > 0
      if confirm("Selecting this folder will permanently delete all sibling tracks. Are you sure you want to continue?")
        for track in selectedSiblingTracks
          track.toggleSelected()
          Fancytree.resetTrackCheckboxes([track], true)
        true
      else
        false

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
