#= require filebrowser/filebrowser_node

class @FilebrowserFileNode extends @FilebrowserNode
  constructor: ->
    @url = "/tracks"
    super

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
      if @node.data.iconclass == 'missing'
        col4.find('a').addClass('secondary').attr('href', '#').find('span').attr('title', 'file missing')

  data: ->
    [projects_datapath_id, path, name] = @buildNode()
    { track: { name: name, path: path, projects_datapath_id: projects_datapath_id } }

  createSuccess: (data, textStatus, jqXHR) ->
    @node.data['object'] = data
    tr = $(@node.tr)
    tr.find('.track-link').html("<a href='" + RAILS_RELATIVE_URL_ROOT + "/tracks/" + data.id + "'>" + data.name + "</a>").attr('title', @node.data.object.name)
    tr.find('.track-genome').html("<span class='label genome'>" + data.genome + "</span>")
    tr.find('.track-igv').html(data.igv)
    $('.track-count').trigger('filebrowserUpdateFileCount')
    super

  destroySuccess: (data, textStatus, jqXHR) ->
    tr = $(@node.tr)
    tr.find('.track-link').html('')
    tr.find('.track-genome').html('')
    tr.find('.track-igv').html('')
    delete @node.data.object
    $('.track-count').trigger('filebrowserUpdateFileCount')
    super

  buildNode: (projectsDatapathId=null) ->
    super
    if projectsDatapathId
      projectsDatapath = $.grep(@parents, (val, i) -> val.data.object != undefined and val.data.object.id == projectsDatapathId)[0]
    else
      projectsDatapath = $.grep(@parents, (val, i) -> val.isSelected())[0]
      projects_datapath_id = projectsDatapath.data.object.id if projectsDatapath.data.object and projectsDatapath.data.object.type == "projects_datapath"
      name = @node.title.replace(/\.[^/.]+$/, "")
    path = $.map(@parents.slice($.inArray(projectsDatapath, @parents)+1), (val, i) -> val.title).join('/')
    [projects_datapath_id, path, name]

  updateNode: (projectsDatapathId) ->
    @url = "/tracks/" + @node.data.object.id
    path = @buildNode(projectsDatapathId)[1]
    @data = { track: { path: path, projects_datapath_id: projectsDatapathId } }
    super
