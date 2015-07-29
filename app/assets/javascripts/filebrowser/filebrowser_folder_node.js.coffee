#= require filebrowser/filebrowser_node

class @FilebrowserFolderNode extends @FilebrowserNode
  constructor: (@node, filebrowser) ->
    @filebrowser = filebrowser
    @url = "/projects_datapaths"

  isSelectable: ->
    $.grep(@node.getParentList(false, true), (node) -> node.isSelected())
      .length > 0

  renderColumns: ->
    super
    col2 = @tdList.eq(2).addClass('projects-datapath-name')
    if @node.isSelected()
      col2.html(@node.data.object.name).attr('title', @node.data.object.name)

  data: ->
    [datapath_id, path, name] = @buildNode()
    { projects_datapath: {datapath_id: datapath_id, project_id: @filebrowser.project_id, path: path, name: name }}

  createSuccess: (jqXHR) ->
    if @node.data.object then $.extend(@node.data.object, jqXHR) else @node.data['object'] = jqXHR
    $(@node.tr).find('.projects-datapath-name').html(jqXHR.name).attr('title', jqXHR.name)
    @resetDatapathHierarchy(jqXHR.id)
    FilebrowserFolderNode.resetFileCheckboxes(@childFiles(), false)
    super

  destroyNode: ->
    if @selectedParent() == undefined and @selectedChildFolders().length == 0
      FilebrowserFolderNode.resetFileCheckboxes(@childFiles(), true)
    super

  destroySuccess: ->
    $(@node.tr).find('.projects-datapath-name').html('').attr('title', '')
    delete @node.data.object.id
    delete @node.data.object.name
    delete @node.data.object.type
    super

  buildNode: ->
    super
    datapath_id = @parents[0].data.object.datapath_id
    path = $.map(@parents, (val, i) -> val.title).slice(1).join('/')
    name = @node.title.split('/').pop()
    [datapath_id, path, name]

  selectedChildFolders: ->
    FilebrowserFolderNode.selectedFolderFilter(FilebrowserFolderNode.deepChildrenList(@node))

  selectedChildFiles: () ->
    FilebrowserFolderNode.selectedFileFilter(FilebrowserFolderNode.deepChildrenList(@node))

  childFiles: ->
    FilebrowserFolderNode.fileFilter(FilebrowserFolderNode.deepChildrenList(@node))

  confirmSelectedFolder: ->
    selectedParent = @selectedParent()
    selectedChildFolders = @selectedChildFolders()
    selectedChildFiles = @selectedChildFiles()
    if selectedParent == undefined and selectedChildFolders.length == 0 and selectedChildFiles.length > 0
      if confirm("Deselecting this folder will permanently delete all child files. Are you sure you want to continue?")
        file.toggleSelected() for file in selectedChildFiles
        true
      else
        false

  confirmUnselectedFolder: ->
    selectedSiblingFiles = FilebrowserNode.selectedFilter(@siblingFiles())
    array = []
    array.push(FilebrowserNode.selectedFilter(Filebrowser.node(parent).siblingFiles())) for parent in @node.getParentList()
    selectedSiblingFilesOfParents = [].concat.apply([], array)
    selectedSiblingFiles = selectedSiblingFiles.concat(selectedSiblingFilesOfParents)
    if selectedSiblingFiles.length > 0
      if confirm("Selecting this folder will permanently delete all sibling files. Are you sure you want to continue?")
        for file in selectedSiblingFiles
          file.toggleSelected()
          FilebrowserNode.resetFileCheckboxes([file], true)
        true
      else
        false

  resetDatapathHierarchy: (projectsDatapathId) ->
    selectedParent = @selectedParent()
    selectedChildFiles = @selectedChildFiles()
    selectedChildFolders = @selectedChildFolders()
    if selectedParent
      Filebrowser.node(selectedParent).resolveOrphanFiles(selectedChildFiles)
      @transitionChildFiles(projectsDatapathId)
      @resetSiblingCheckboxes()
      @resetParentCheckboxes()
      selectedParent.toggleSelected()
    else if selectedChildFolders.length > 0
      for folder in selectedChildFolders
        Filebrowser.node(folder).transitionChildFiles(projectsDatapathId)
        folder.toggleSelected()
      children = FilebrowserFolderNode.deepChildrenList(@node)
      FilebrowserNode.resetFileCheckboxes(FilebrowserNode.fileFilter(children), false)
    else if selectedChildFiles.length > 0
      @transitionChildFiles(projectsDatapathId)

  resolveOrphanFiles: (childFiles) ->
    selectedParentChildFiles = @selectedChildFiles()
    newProjectsDatapaths = []
    orphanFiles = $(selectedParentChildFiles).not(childFiles).get()
    for orphanFile in orphanFiles
      orphanFileParentList = orphanFile.getParentList()
      newProjectsDatapaths.push(orphanFileParentList[orphanFileParentList.length - 1])
    uniqueNewProjectsDatapaths = newProjectsDatapaths.filter((elem, pos) -> newProjectsDatapaths.indexOf(elem) == pos)
    for projectsDatapath in uniqueNewProjectsDatapaths
      parents = projectsDatapath.getParentList()
      overlap = parents.filter((n) -> uniqueNewProjectsDatapaths.indexOf(n) != -1)
      projectsDatapath.toggleSelected() unless overlap.length > 0

  transitionChildFiles: (projectsDatapathId) ->
    for file in @selectedChildFiles()
      Filebrowser.node(file).updateNode(projectsDatapathId)

  resetSiblingCheckboxes: ->
    for sibling in @siblingFolders().concat(@siblingFiles())
      if sibling.isFolder() && !sibling.isSelected() && Filebrowser.node(sibling).selectedChildFolders().length == 0
        FilebrowserNode.resetFileCheckboxes(Filebrowser.node(sibling).childFiles(), true)
      else if !sibling.isFolder()
        FilebrowserNode.resetFileCheckboxes([sibling], true)

  resetParentCheckboxes: ->
    for parent in @node.getParentList()
      FilebrowserNode.resetFileCheckboxes(Filebrowser.node(parent).siblingFiles(), true)

  @deepChildrenList: (node, array = []) ->
    node = node.getFirstChild()
    while node
      array.push(node)
      FilebrowserFolderNode.deepChildrenList(node, array)
      node = node.getNextSibling()
    array
