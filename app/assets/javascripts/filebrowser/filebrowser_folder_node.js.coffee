#= require filebrowser/filebrowser_node

class @FilebrowserFolderNode extends @FilebrowserNode
  isSelectable: ->
    $.grep(@node.getParentList(false, true), (node) -> node.isSelected())
      .length > 0

  renderColumns: ->
    super
    col2 = @tdList.eq(2).addClass('projects-datapath-name')
    if @node.isSelected()
      col2.html(@node.data.object.name).attr('title', @node.data.object.name)

  createNode: (project_id) ->
    @url = "/projects_datapaths"
    [datapath_id, path, name] = @buildNode()
    @data = { projects_datapath: {datapath_id: datapath_id, project_id: project_id, path: path, name: name }}
    super

  createSuccess: (jqXHR) ->
    @resetDatapathHierarchy(jqXHR.id)
    FilebrowserFolderNode.resetFileCheckboxes(@childFiles(), false)
    if @node.data.object then $.extend(@node.data.object, jqXHR) else @node.data['object'] = jqXHR
    $(@node.tr).find('.projects-datapath-name').html(jqXHR.name).attr('title', jqXHR.name)
    super

  destroyNode: ->
    if @selectedParent() == undefined and @selectedChildFolders().length == 0
      FilebrowserFolderNode.resetFileCheckboxes(@childFiles(), true)
    @url = "/projects_datapaths/" + @node.data.object.id
    super

  destroySuccess: ->
    $(@node.tr).find('.projects-datapath-name').html('').attr('title', '')
    delete @node.data.object.id
    delete @node.data.object.name
    delete @node.data.object.type
    super

  buildNode: ->
    parents = @node.getParentList(false, true)
    datapath_id = parents[0].data.object.datapath_id
    path = $.map(parents, (val, i) -> val.title).slice(1).join('/')
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

  resetDatapathHierarchy: (projects_datapath_id) ->
    selectedParent = @selectedParent()
    if selectedParent
      selectedParent.toggleSelected()

  @deepChildrenList: (node, array = []) ->
    node = node.getFirstChild()
    while node
      array.push(node)
      FilebrowserFolderNode.deepChildrenList(node, array)
      node = node.getNextSibling()
    array
