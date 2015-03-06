class @Fancytree
  project_id = $('#track-tree').data('project')

  @applyFancytree: ->
    $('#track-tree').fancytree {
      source:
        url: "/projects_datapaths/browser?id=" + project_id
      checkbox: true
      selectMode: 2
      extensions: ["table"]
      table: {
        checkboxColumnIdx: 0 # render the checkboxes into the this column index (default: nodeColumnIdx)
        nodeColumnIdx: 1     # render node expander, icon, and title to this column (default: #0)
        indentation: 16      # indent every node level by 16px
      }
      renderColumns: (event, data) ->
        node = data.node
        $tdList = $(node.tr).find(">td")
        # (index #0 is rendered by fancytree by adding the checkbox)
        # (index #1 is rendered by fancytree)
        $tdList.eq(2).text(node.key)
      select: (event, data) ->
        attr = Fancytree.buildPath(event, data)
        if data.node.selected
          Fancytree.addNode(event, data, attr[0], attr[1])
        else
          Fancytree.deleteNode(event, data, attr[0], attr[1])
    }

  @buildPath: (event, data) ->
    parent_list = data.node.getParentList()
    if parent_list.length > 0
      datapath_id = parent_list[0].key
      dir_array = []
      for i of parent_list
        dir_array.push(parent_list[i].title)
      sub_array = dir_array.slice(1)
      sub_array.push(data.node.title)
      sub_dir = sub_array.join('/')
    else
      datapath_id = data.node.key
      sub_dir = ""
    [datapath_id, sub_dir]

  @addNode: (event, data, datapath_id, sub_dir) ->
    node = data.node
    $.ajax({
      type: "POST",
      url: "/projects_datapaths",
      data: { projects_datapath: { datapath_id: datapath_id, project_id: project_id, sub_directory: sub_dir } },
      success:(jqXHR, textStatus, errorThrown) ->
        node.data['projects_datapath_id'] = jqXHR['projects_datapath_id']
        $span = $(node.span)
        $span.effect("highlight", {}, 1500)
        return false
      error:(jqXHR, textStatus, errorThrown) ->
        $span = $(node.span)
        $span.addClass('error-red')
        $span.parents('tr').removeClass('fancytree-selected')
        $span.find('.fancytree-title').append(' [' + errorThrown.trim() + ']')
        return false
    })

  @deleteNode: (event, data, datapath_id, sub_dir) ->
    node = data.node
    $.ajax({
      type: "POST",
      url: "/projects_datapaths/" + node.data.projects_datapath_id
      data: { _method: "delete" },
      success:(jqXHR, textStatus, errorThrown) ->
        $span = $(node.span)
        $span.effect("highlight", {}, 1500)
        return false
      error:(jqXHR, textStatus, errorThrown) ->
        $span = $(node.span)
        $span.addClass('error-red')
        $span.find('.fancytree-title').append(' [' + errorThrown.trim() + ']')
        return false
    })
