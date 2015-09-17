#= require filebrowser/filebrowser_node

class @FilebrowserFolderNode extends @FilebrowserNode
  constructor: ->
    @url = "/projects_datapaths"
    super

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

  createSuccess: (data, textStatus, jqXHR) ->
    if @node.data.object then $.extend(@node.data.object, data) else @node.data['object'] = data
    $(@node.tr).find('.projects-datapath-name').html(data.name).attr('title', data.name)
    @resetDatapathHierarchy(data.id)
    FilebrowserFolderNode.resetFileCheckboxes(@childFiles(), false)
    super

  destroyNode: ->
    if @selectedParent() == undefined and @selectedChildFolders().length == 0
      FilebrowserFolderNode.resetFileCheckboxes(@childFiles(), true)
    super

  destroySuccess: (data, textStatus, jqXHR) ->
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

  selectedChildFiles: ->
    FilebrowserFolderNode.selectedFileFilter(FilebrowserFolderNode.deepChildrenList(@node))

  childFiles: ->
    FilebrowserFolderNode.fileFilter(FilebrowserFolderNode.deepChildrenList(@node))

  selectedParent: ->
    FilebrowserFolderNode.selectedFilter(@node.getParentList())[0]

  siblingFiles: ->
    FilebrowserFolderNode.fileFilter(@node.getParent().children)

  siblingFolders: ->
    FilebrowserFolderNode.folderFilter(@node.getParent().children)

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
    selectedSiblingFiles = FilebrowserFolderNode.selectedFilter(@siblingFiles())
    array = []
    array.push(FilebrowserFolderNode.selectedFilter(Filebrowser.node(parent).siblingFiles())) for parent in @node.getParentList()
    selectedSiblingFilesOfParents = [].concat.apply([], array)
    selectedSiblingFiles = selectedSiblingFiles.concat(selectedSiblingFilesOfParents)
    if selectedSiblingFiles.length > 0
      if confirm("Selecting this folder will permanently delete all sibling files. Are you sure you want to continue?")
        for file in selectedSiblingFiles
          file.toggleSelected()
          FilebrowserFolderNode.resetFileCheckboxes([file], true)
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
      FilebrowserFolderNode.resetFileCheckboxes(FilebrowserFolderNode.fileFilter(children), false)
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
        FilebrowserFolderNode.resetFileCheckboxes(Filebrowser.node(sibling).childFiles(), true)
      else if !sibling.isFolder()
        FilebrowserFolderNode.resetFileCheckboxes([sibling], true)

  resetParentCheckboxes: ->
    for parent in @node.getParentList()
      FilebrowserFolderNode.resetFileCheckboxes(Filebrowser.node(parent).siblingFiles(), true)
      # TODO: calling Filebrowser here might call for moving that method to FilebrowserNode

  @deepChildrenList: (node, array = []) ->
    node = node.getFirstChild()
    while node
      array.push(node)
      FilebrowserFolderNode.deepChildrenList(node, array)
      node = node.getNextSibling()
    array

  @selectedFilter: (nodes) ->
    $.grep(nodes, (node) -> node.isSelected())

  @selectedFolderFilter: (nodes) ->
    $.grep(nodes, (node) -> node.isSelected() and node.isFolder())

  @selectedFileFilter: (nodes) ->
    $.grep(nodes, (node) -> node.isSelected() and !node.isFolder())

  @fileFilter: (nodes) ->
    $.grep(nodes, (node) -> !node.isFolder())

  @folderFilter: (nodes) ->
    $.grep(nodes, (node) -> node.isFolder())

  @resetFileCheckboxes: (files, remove) ->
    for file in files
      tr = $(file.tr)
      if remove
        file.hideCheckbox = true
        tr.find('td span').first().removeClass('fancytree-checkbox')
      else
        file.hideCheckbox = false
        tr.find('td').first().html("<span class='fancytree-checkbox'></span>")
