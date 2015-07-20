#= require filebrowser/filebrowser_node

class @FilebrowserFolderNode extends @FilebrowserNode
  isSelectable: ->
    $.grep(@node.getParentList(false, true), (node) -> node.isSelected())
      .length > 0

  renderColumns: (node) ->
    tdList = $(node.tr).find(">td")
    tdList.eq(1).attr('title', node.title)
    col2 = tdList.eq(2).addClass('projects-datapath-name')
    if node.isSelected()
      col2.html(node.data.object.name).attr('title', node.data.object.name)

  createNode: (project_id) ->
    [datapath_id, path, name] = this.buildNode()
    $.ajax
      type: "POST"
      dataType: "json"
      url: RAILS_RELATIVE_URL_ROOT + "/projects_datapaths"
      data: { projects_datapath: {datapath_id: datapath_id, project_id: project_id, path: path, name: name }}
      context: this
      success: (jqXHR, textStatus, errorThrown) ->
        # Fancytree.resetDatapathHierarchy(node, jqXHR.projects_datapath.id)
        if @node.data.object then $.extend(@node.data.object, jqXHR) else @node.data['object'] = jqXHR
        $(@node.tr).find('.projects-datapath-name').html(jqXHR.name).attr('title', jqXHR.name)
        FilebrowserNode.ajaxSuccess(@node)
      error: FilebrowserNode.ajaxError

  destroyNode: ->
    [datapath_id, path, name] = this.buildNode()
    # if Fancytree.selectedParent(node) == undefined and Fancytree.selectedChildFolders(node).length == 0
    #   Fancytree.resetTrackCheckboxes(Fancytree.childTracks(node), true)
    $.ajax
      type: "POST"
      dataType: "json"
      url: RAILS_RELATIVE_URL_ROOT + "/projects_datapaths/" + @node.data.object.id
      data: { _method: "delete" }
      context: this
      success: (jqXHR, textStatus, errorThrown) ->
        $(@node.tr).find('.projects-datapath-name').html('').attr('title', '')
        delete @node.data.object.id
        delete @node.data.object.name
        delete @node.data.object.type
        FilebrowserNode.ajaxSuccess(@node)
      error: FilebrowserNode.ajaxError

  buildNode: ->
    parents = @node.getParentList(false, true)
    datapath_id = parents[0].data.object.datapath_id
    path = $.map(parents, (val, i) -> val.title).slice(1).join('/')
    name = @node.title.split('/').pop()
    [datapath_id, path, name]
