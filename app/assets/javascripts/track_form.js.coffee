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
    @deleteTrack()
    @enableEdit()
    @toggleDelete()
    event.preventDefault() if event?

  toggleDelete: ->
    @group.find('.remove-track').toggle()

  enableEdit: ->
    @group.find('.track-name').toggleClass('line-through edit-track no-pointer')

  deleteTrack: ->
    @group.find('input[type=hidden]').val('0')

  toggleRestore: ->
    @group.find('.restore-track').toggle()

  updateName: ->
    text = @group.find("label:contains('Name')").next().val()
    @group.find('.track-name').text(text)

  toggleName: ->
    @group.find('.track-name').toggle()

  toggleFields: ->
    @group.find('.track-form-fields').toggle()

  toggleDone: ->
    @actions().find('.done-track').toggle()

  actions: ->
    @group.find('.inline-list')

  toggleEditBox: ->
    @group.toggleClass('edit-record')



  @fields: (el) ->
    TrackForm.findGroup(el).find('.track-form-fields')

  @links: (el) ->
    el.closest('li').siblings()

  @removeTrack: (el) ->
    if TrackForm.findGroup(el).hasClass('new-record')
      TrackForm.findGroup(el).remove()
    else if TrackForm.findGroup(el).hasClass('edit-record')
      el.hide()
      TrackForm.findGroup(el).find('input[type=hidden]').val('1')
      TrackForm.findGroup(el).removeClass('edit-record')
      TrackForm.fields(el).hide()
      TrackForm.links(el).find('.edit-track').show().toggleClass('line-through edit-track no-pointer')
      TrackForm.links(el).find('.done-track').hide()
      TrackForm.links(el).find('.restore-track').show()
    else
      el.hide()
      TrackForm.findGroup(el).find('input[type=hidden]').val('1')
      TrackForm.links(el).find('.edit-track').toggleClass('line-through edit-track no-pointer')
      TrackForm.links(el).find('.restore-track').show()
    event.preventDefault()
    TrackForm.change_track_add_text()

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
