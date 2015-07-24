class @FilebrowserNode
  constructor: (@node) ->

  fullpath: ->
    $.map(@node.getParentList(false, true), (val, i) ->
      val.title
    ).join("/")

  isSelected: ->
    @node.isSelected()

  renderColumns: ->
    @tdList = $(@node.tr).find(">td")
    @tdList.eq(1).attr('title', @node.title)

  createNode: ->
    @ajaxRequest("POST", @url, @data, @createSuccess, FilebrowserNode.ajaxError)

  destroyNode: ->
    @ajaxRequest("POST", @url, { _method: "delete" }, @destroySuccess, FilebrowserNode.ajaxError)

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

  createSuccess:  ->
    FilebrowserNode.ajaxSuccess(@node)

  destroySuccess: ->
    FilebrowserNode.ajaxSuccess(@node)

  updateSuccess: ->
    FilebrowserNode.ajaxSuccess(@node)

  selectedParent: ->
    FilebrowserNode.selectedFolderFilter(@node.getParentList())[0]

  siblingFiles: ->
    FilebrowserNode.fileFilter(@node.getParent().children)

  @selectedFilter: (nodes) ->
    $.grep(nodes, (node) -> node.isSelected())

  @selectedFolderFilter: (nodes) ->
    $.grep(nodes, (node) -> node.isSelected() and node.isFolder())

  @selectedFileFilter: (nodes) ->
    $.grep(nodes, (node) -> node.isSelected() and !node.isFolder())

  @fileFilter: (nodes) ->
    $.grep(nodes, (node) -> !node.isFolder())

  @resetFileCheckboxes: (files, remove) ->
    for file in files
      tr = $(file.tr)
      if remove
        file.hideCheckbox = true
        tr.find('td span').first().removeClass('fancytree-checkbox')
      else
        file.hideCheckbox = false
        tr.find('td').first().html("<span class='fancytree-checkbox'></span>")

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
