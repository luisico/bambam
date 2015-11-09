class @FilebrowserNode
  constructor: (@node, @filebrowser) ->
    throw new Error('url not defined') unless @url?

  fullpath: ->
    $.map(@node.getParentList(false, true), (val, i) ->
      val.title
    ).join("/")

  isSelected: ->
    @node.isSelected()

  renderColumns: ->
    @tdList = $(@node.tr).find(">td")
    if @node.data.iconclass == 'missing' then title = 'missing from disk' else title = @node.title
    @tdList.eq(1).attr('title', title)

  createNode: ->
    @ajaxRequest("POST", @url, @data(), @createSuccess, FilebrowserNode.ajaxError)

  destroyNode: ->
    @ajaxRequest("POST", @url + "/" + @node.data.object.id, { _method: "delete" }, @destroySuccess, FilebrowserNode.ajaxError)

  updateNode: ->
    @ajaxRequest("PATCH", @url, @data, @updateSuccess, FilebrowserNode.ajaxError)

  buildNode: ->
    @parents = @node.getParentList(false, true)

  ajaxRequest: (type, url, data, success, error) ->
    $.ajax
      type: type
      dataType: "json"
      url: RAILS_RELATIVE_URL_ROOT + url
      data: data
      context: this
      success: success
      error: error

  createSuccess: (data, textStatus, jqXHR) ->
    FilebrowserNode.ajaxSuccess(@node)

  destroySuccess: (data, textStatus, jqXHR) ->
    FilebrowserNode.ajaxSuccess(@node)

  updateSuccess: (data, textStatus, jqXHR) ->
    FilebrowserNode.ajaxSuccess(@node)

  @ajaxSuccess: (node) ->
    tr = $(node.tr)
    tr.effect("highlight", {}, 1500) if tr.is(':visible')
    return false

  @ajaxError: (jqXHR, textStatus, errorThrown) ->
    errorMessage = if jqXHR.responseJSON then jqXHR.responseJSON.message else errorThrown
    tr = $(@node.tr).addClass('error-red')
    tr.toggleClass('fancytree-selected')
    tr.find('.fancytree-title').append(' [' + errorMessage + ']')
    return false
