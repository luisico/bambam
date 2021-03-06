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
    @resetChildCheckboxes(false)
    super

  destroyNode: ->
    if @selectedParent() == undefined and @selectedChildFolders().length == 0
      @resetChildCheckboxes(true)
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
    FilebrowserFolderNode.selectedFolders(new FilebrowserFolderNode(@node).deepChildren())

  selectedChildFiles: ->
    FilebrowserFolderNode.selectedFiles(new FilebrowserFolderNode(@node).deepChildren())

  childFiles: ->
    FilebrowserFolderNode.files(new FilebrowserFolderNode(@node).deepChildren())

  selectedParent: ->
    FilebrowserFolderNode.selected(@node.getParentList())[0]

  siblingFiles: ->
    FilebrowserFolderNode.files(@node.getParent().children)

  siblingFolders: ->
    FilebrowserFolderNode.folders(@node.getParent().children)

  confirmSelectedFolder: ->
    selected_files = @selectedChildFiles()
    if @selectedParent() == undefined and @selectedChildFolders().length == 0 and selected_files.length > 0
      if confirm("Deselecting this folder will permanently delete all child files. Are you sure you want to continue?")
        file.toggleSelected() for file in selected_files
        true
      else
        false

  confirmUnselectedFolder: ->
    siblings = FilebrowserFolderNode.selected(@siblingFiles())
    array = []
    array.push(FilebrowserFolderNode.selected(Filebrowser.node(parent).siblingFiles())) for parent in @node.getParentList()
    selected_sibling_files_of_parents = [].concat.apply([], array)
    siblings = siblings.concat(selected_sibling_files_of_parents)
    if siblings.length > 0
      if confirm("Selecting this folder will permanently delete all sibling files. Are you sure you want to continue?")
        for file in siblings
          file.toggleSelected()
          new FilebrowserFolderNode(file).resetCheckbox(true)
        true
      else
        false

  resetDatapathHierarchy: (projectsDatapathId) ->
    parent = @selectedParent()
    folders = @selectedChildFolders()
    files = @selectedChildFiles()
    if parent
      Filebrowser.node(parent).resolveOrphans(files)
      @transitionFiles(projectsDatapathId)
      @resetSiblingCheckboxes()
      @resetParentCheckboxes()
      parent.toggleSelected()
    else if folders.length > 0
      for folder in folders
        Filebrowser.node(folder).transitionFiles(projectsDatapathId)
        folder.toggleSelected()
      @resetChildCheckboxes(false)
    else if files.length > 0
      @transitionFiles(projectsDatapathId)

  resolveOrphans: (childFiles) ->
    folders = []
    for orphan in $(@selectedChildFiles()).not(childFiles).get()
      parents = orphan.getParentList()
      folders.push(parents[parents.length - 1])
    unique_folders = folders.filter((elem, pos) -> folders.indexOf(elem) == pos)
    for folder in unique_folders
      parents = folder.getParentList()
      overlap = parents.filter((n) -> unique_folders.indexOf(n) != -1)
      folder.toggleSelected() unless overlap.length > 0

  transitionFiles: (projectsDatapathId) ->
    for file in @selectedChildFiles()
      Filebrowser.node(file).updateNode(projectsDatapathId)

  resetCheckbox: (remove) ->
    tr = $(@node.tr)
    if remove
      @node.hideCheckbox = true
      tr.find('td span').first().removeClass('fancytree-checkbox')
    else
      @node.hideCheckbox = false
      tr.find('td').first().html("<span class='fancytree-checkbox'></span>")

  resetChildCheckboxes: (remove) ->
    for child in @childFiles()
      new FilebrowserFolderNode(child).resetCheckbox(remove)

  resetSiblingCheckboxes: ->
    for sibling in @siblingFolders().concat(@siblingFiles())
      if sibling.isFolder() && !sibling.isSelected() && Filebrowser.node(sibling).selectedChildFolders().length == 0
        new FilebrowserFolderNode(sibling).resetChildCheckboxes(true)
      else if !sibling.isFolder()
        new FilebrowserFolderNode(sibling).resetCheckbox(true)

  resetParentCheckboxes: ->
    for parent in @node.getParentList()
      for sibling in new FilebrowserFolderNode(parent).siblingFiles()
        new FilebrowserFolderNode(sibling).resetCheckbox(true)

  deepChildren: (array = []) ->
    node = @node.getFirstChild()
    while node
      array.push(node)
      new FilebrowserFolderNode(node).deepChildren(array)
      node = node.getNextSibling()
    array

  @selected: (nodes) ->
    $.grep(nodes, (node) -> node.isSelected())

  @selectedFolders: (nodes) ->
    $.grep(nodes, (node) -> node.isSelected() and node.isFolder())

  @selectedFiles: (nodes) ->
    $.grep(nodes, (node) -> node.isSelected() and !node.isFolder())

  @files: (nodes) ->
    $.grep(nodes, (node) -> !node.isFolder())

  @folders: (nodes) ->
    $.grep(nodes, (node) -> node.isFolder())
