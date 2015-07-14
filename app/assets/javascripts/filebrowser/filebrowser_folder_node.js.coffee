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
