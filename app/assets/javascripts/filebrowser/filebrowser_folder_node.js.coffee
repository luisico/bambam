#= require filebrowser/filebrowser_node

class @FilebrowserFolderNode extends @FilebrowserNode
  isSelectable: ->
    $.grep(@node.getParentList(false, true), (node) -> node.isSelected())
      .length > 0
