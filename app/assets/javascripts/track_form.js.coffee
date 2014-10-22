class @TrackForm
  constructor: (el, event) ->
    @group = TrackForm.findGroup(el)

  @findGroup: (el) ->
    $(el).closest('div.track-form-group')

  edit: (event) ->
    @toggleEditBox()
    event.preventDefault() if event?

  done: (event) ->
    @toggleEditBox()
    @updateName()
    event.preventDefault() if event?

  restore: (event) ->
    @toggleRestore()
    @restoreTrack()
    @toggleEditLink()
    @toggleDelete()
    event.preventDefault() if event?

  delete: (event) ->
    if @group.hasClass('new-record')
      @group.remove()
    else if @group.hasClass('edit-record')
      @toggleDelete()
      @deleteTrack()
      @toggleEditBox()
      @toggleEditLink()
      @toggleRestore()
    else
      @toggleDelete()
      @deleteTrack()
      @toggleEditLink()
      @toggleRestore()
    event.preventDefault() if event?
    TrackForm.change_track_add_text()

  findTrack: ->
    @group.find('.track-name')

  toggleEditBox: ->
    @group.toggleClass('edit-record')
    @findTrack().toggle()
    @group.find('.track-form-fields').toggle()
    @actions().find('.done-track').toggle()

  toggleDelete: ->
    @group.find('.remove-track').toggle()

  toggleEditLink: ->
    @findTrack().toggleClass('line-through edit-track no-pointer')

  restoreTrack: ->
    @group.find('input[type=hidden]').val('0')

  deleteTrack: ->
    @group.find('input[type=hidden]').val('1')

  toggleRestore: ->
    @group.find('.restore-track').toggle()

  updateName: ->
    text = @group.find("label:contains('Name')").next().val()
    @findTrack().text(text)

  actions: ->
    @group.find('.inline-list')



  @addTrack: (el) ->
    time = new Date().getTime()
    regexp = new RegExp(el.data('id'), 'g')
    el.before(el.data('fields').replace(regexp, time))
    event.preventDefault()
    $.when(event).done(el.siblings('.new-record').find('.track-form-fields').show())
    TrackForm.change_track_add_text()

  @change_track_add_text = ->
    if $('.track-form-group').length > 0
      $('.add_fields').text('Add another track')
    else
      $('.add_fields').text('Add a track')
