class @FilebrowserNode
  constructor: (@node) ->

  fullpath: ->
    $.map(@node.getParentList(false, true), (val, i) ->
      val.title
    ).join("/")
