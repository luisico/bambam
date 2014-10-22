class @TrackForm
  constructor: (el, event) ->
    @group = TrackForm.findGroup(el)

  @findGroup: (el) ->
    $(el).closest('div.track-form-group')

  edit: (event) ->
    @toggleEditBox()
    @toggleName()
    @toggleFields()
    @toggleDone()
    event.preventDefault() if event?

  done: (event) ->
    @toggleEditBox()
    @toggleName()
    @toggleFields()
    @toggleDone()
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
      @toggleFields()
      @toggleEditLink()
      @toggleName()
      @toggleDone()
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

  toggleName: ->
    @findTrack().toggle()

  toggleFields: ->
    @group.find('.track-form-fields').toggle()

  toggleDone: ->
    @actions().find('.done-track').toggle()

  actions: ->
    @group.find('.inline-list')

  toggleEditBox: ->
    @group.toggleClass('edit-record')



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
