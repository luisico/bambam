#= require filebrowser/filebrowser_node

class @FilebrowserFileNode extends @FilebrowserNode
  isSelectable: ->
    $.grep(@node.getParentList(), (node) -> node.isSelected())
      .length > 0
