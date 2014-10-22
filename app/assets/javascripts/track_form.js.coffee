class @TrackForm
  constructor: (el, event) ->
    @group = TrackForm.findGroup(el)

  @findGroup: (el) ->
    $(el).closest('div.track-form-group')

  edit: (event) ->
    @group.addClass('edit-record')
    @hideName()
    @showFields()
    @showDone()
    event.preventDefault() if event?

  hideName: ->
    @group.find('.track-name').hide()

  showFields: ->
    @group.find('.track-form-fields').show()

  showDone: ->
    @actions().find('.done-track').show()

  actions: ->
    @group.find('.inline-list')



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

  @doneTrack: (el) ->
    el.hide()
    TrackForm.findGroup(el).removeClass('edit-record')
    TrackForm.fields(el).hide()
    text = TrackForm.findGroup(el).find("label:contains('Name')").next().val()
    TrackForm.links(el).find('.track-name').show().text(text)
    TrackForm.links(el).find('.remove-track').show()
    event.preventDefault()

  @restoreTrack: (el) ->
    el.hide()
    TrackForm.fields(el).find('input[type=hidden]').val('0')
    TrackForm.links(el).find('.track-name').show().toggleClass('line-through edit-track no-pointer')
    TrackForm.links(el).find('.remove-track').show()
    event.preventDefault()

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
