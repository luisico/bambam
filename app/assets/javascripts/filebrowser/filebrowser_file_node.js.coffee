#= require filebrowser/filebrowser_node

class @FilebrowserFileNode extends @FilebrowserNode
  isSelectable: ->
    $.grep(@node.getParentList(), (node) -> node.isSelected())
      .length > 0

  renderColumns: ->
    super
    col2 = @tdList.eq(2).addClass('track-link')
    col3 = @tdList.eq(3).addClass('track-genome')
    col4 = @tdList.eq(4).addClass('track-igv')
    if @node.isSelected()
      col2.html("<a href='" + RAILS_RELATIVE_URL_ROOT + "/tracks/" + @node.data.object.id + "'>" + @node.data.object.name + "</a>").attr('title', @node.data.object.name)
      col3.html("<span class='label genome'>" + @node.data.object.genome + "</span>")
      col4.html(@node.data.object.igv)

  createNode: ->
    [projects_datapath_id, path, name] = this.buildNode()
    $.ajax
      type: "POST"
      dataType: "json"
      url: RAILS_RELATIVE_URL_ROOT + "/tracks"
      data: { track: { name: name, path: path, projects_datapath_id: projects_datapath_id } }
      context: this
      success: (jqXHR, textStatus, errorThrown) ->
        @node.data['object'] = jqXHR
        tr = $(@node.tr)
        tr.find('.track-link').html("<a href='" + RAILS_RELATIVE_URL_ROOT + "/tracks/" + jqXHR.id + "'>" + jqXHR.name + "</a>").attr('title', @node.data.object.name)
        tr.find('.track-genome').html("<span class='label genome'>" + jqXHR.genome + "</span>")
        tr.find('.track-igv').html(jqXHR.igv)
        Project.updateTracksCount()
        FilebrowserFileNode.ajaxSuccess
      error: FilebrowserFileNode.ajaxError

  destroyNode: ->
    $.ajax
      type: "POST"
      dataType: "json"
      url: RAILS_RELATIVE_URL_ROOT + "/tracks/" + @node.data.object.id
      data: { _method: "delete" }
      context: this
      success: (jqXHR, textStatus, errorThrown) ->
        tr = $(@node.tr)
        tr.find('.track-link').html('')
        tr.find('.track-genome').html('')
        tr.find('.track-igv').html('')
        delete @node.data.object
        Project.updateTracksCount()
        FilebrowserFileNode.ajaxSuccess
      error: FilebrowserFileNode.ajaxError

  buildNode: ->
    parents = @node.getParentList(false, true)
    selected = $.grep(parents, (val, i) -> val.isSelected())[0]
    projects_datapath_id = selected.data.object.id if selected.data.object and selected.data.object.type == "projects_datapath"
    path = $.map(parents.slice($.inArray(selected, parents)+1), (val, i) -> val.title).join('/')
    name = @node.title.replace(/\.[^/.]+$/, "")
    [projects_datapath_id, path, name]
