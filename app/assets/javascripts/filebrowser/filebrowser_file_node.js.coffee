#= require filebrowser/filebrowser_node

class @FilebrowserFileNode extends @FilebrowserNode
  isSelectable: ->
    $.grep(@node.getParentList(), (node) -> node.isSelected())
      .length > 0

  renderColumns: ->
    tdList = $(@node.tr).find(">td")
    tdList.eq(1).attr('title', @node.title)
    col2 = tdList.eq(2).addClass('track-link')
    col3 = tdList.eq(3).addClass('track-genome')
    col4 = tdList.eq(4).addClass('track-igv')
    if @node.isSelected()
      col2.html("<a href='" + RAILS_RELATIVE_URL_ROOT + "/tracks/" + @node.data.object.id + "'>" + @node.data.object.name + "</a>").attr('title', @node.data.object.name)
      col3.html("<span class='label genome'>" + @node.data.object.genome + "</span>")
      col4.html(@node.data.object.igv)
