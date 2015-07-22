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
    url = "/projects_datapaths"
    [datapath_id, path, name] = this.buildNode()
    data = { projects_datapath: {datapath_id: datapath_id, project_id: project_id, path: path, name: name }}
    this.ajaxRequest(url, data)

  createSuccess: (jqXHR) ->
    # Fancytree.resetDatapathHierarchy(node, jqXHR.projects_datapath.id)
    FilebrowserFolderNode.resetFileCheckboxes(this.childFiles(), false)
    if @node.data.object then $.extend(@node.data.object, jqXHR) else @node.data['object'] = jqXHR
    $(@node.tr).find('.projects-datapath-name').html(jqXHR.name).attr('title', jqXHR.name)

  destroyNode: ->
    if this.selectedParent() == undefined and this.selectedChildFolders().length == 0
      FilebrowserFolderNode.resetFileCheckboxes(this.childFiles(), true)
    url = "/projects_datapaths/" + @node.data.object.id
    this.ajaxRequest(url)

  destroySuccess: () ->
    $(@node.tr).find('.projects-datapath-name').html('').attr('title', '')
    delete @node.data.object.id
    delete @node.data.object.name
    delete @node.data.object.type

  buildNode: ->
    parents = @node.getParentList(false, true)
    datapath_id = parents[0].data.object.datapath_id
    path = $.map(parents, (val, i) -> val.title).slice(1).join('/')
    name = @node.title.split('/').pop()
    [datapath_id, path, name]

  selectedChildFolders: ->
    FilebrowserFolderNode.selectedFolderFilter(FilebrowserFolderNode.deepChildrenList(@node))

  childFiles: ->
    FilebrowserFolderNode.fileFilter(FilebrowserFolderNode.deepChildrenList(@node))

  @deepChildrenList: (node, array = []) ->
    node = node.getFirstChild()
    while node
      array.push(node)
      FilebrowserFolderNode.deepChildrenList(node, array)
      node = node.getNextSibling()
    array
