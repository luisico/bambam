class @FilebrowserNode
  constructor: (@node) ->

  fullpath: ->
    $.map(@node.getParentList(false, true), (val, i) ->
      val.title
    ).join("/")

  isSelected: ->
    @node.isSelected()

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
