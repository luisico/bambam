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

  ajaxRequest: (url, data=null) ->
    $.ajax
      type: "POST"
      dataType: "json"
      url: RAILS_RELATIVE_URL_ROOT + url
      data: data || { _method: "delete" }
      context: this
      success: (jqXHR, textStatus, errorThrown) ->
        if data then this.createSuccess(jqXHR, textStatus, errorThrown) else this.destroySuccess(jqXHR, textStatus, errorThrown)
        FilebrowserNode.ajaxSuccess
      error: FilebrowserNode.ajaxError

  selectedParent: ->
    FilebrowserNode.selectedFolderFilter(@node.getParentList())[0]

  @selectedFolderFilter: (nodes) ->
    $.grep(nodes, (node) -> node.isSelected() and node.isFolder())

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

  @ajaxSuccess: ->
    tr = $(@node.tr)
    tr.effect("highlight", {}, 1500) if tr.is(':visible')
    return false

  @ajaxError: (jqXHR, textStatus, errorThrown) ->
    errorMessage = if jqXHR.responseJSON then jqXHR.responseJSON.message else errorThrown
    tr = $(@node.tr).addClass('error-red')
    tr.toggleClass('fancytree-selected')
    tr.find('.fancytree-title').append(' [' + errorMessage + ']')
    return false
