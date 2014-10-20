class @TrackForm
  @group: (el) ->
    el.closest('div.track-form-group')

  @links: (el) ->
    el.closest('li').siblings()

  @removeTrack: (el) ->
    if TrackForm.group(el).hasClass('new-record')
      TrackForm.group(el).remove()
    else if TrackForm.group(el).hasClass('edit-record')
      el.hide()
      TrackForm.group(el).find('input[type=hidden]').val('1')
      TrackForm.group(el).removeClass('edit-record')
      TrackForm.group(el).children('div.track-form-fields').hide()
      TrackForm.links(el).find('.edit-track').show().addClass('line-through')
      TrackForm.links(el).find('.done-track').hide()
      TrackForm.links(el).find('.restore-track').show()
    else
      el.hide()
      TrackForm.group(el).find('input[type=hidden]').val('1')
      TrackForm.links(el).find('.edit-track').addClass('line-through')
      TrackForm.links(el).find('.restore-track').show()
    event.preventDefault()
    TrackForm.change_track_add_text()

  @editTrack: (el) ->
    el.hide()
    TrackForm.group(el).addClass('edit-record')
    TrackForm.group(el).children('div').show()
    TrackForm.links(el).find('.done-track').show()
    event.preventDefault()

  @doneTrack: (el) ->
    el.hide()
    TrackForm.group(el).removeClass('edit-record')
    TrackForm.group(el).children('div').hide()
    text = TrackForm.group(el).children('div.track-form-fields').find('input').first().val()
    TrackForm.links(el).find('.remove-track').show()
    TrackForm.links(el).find('.track-name').show().text(text)
    event.preventDefault()

  @restoreTrack: (el) ->
    el.hide()
    TrackForm.group(el).children('div.track-form-fields').children('input[type=hidden]').val('0')
    TrackForm.links(el).find('.edit-track').show().removeClass('line-through')
    TrackForm.links(el).find('.remove-track').show()
    event.preventDefault()

  @addTrack: (el) ->
    time = new Date().getTime()
    regexp = new RegExp(el.data('id'), 'g')
    el.before(el.data('fields').replace(regexp, time))
    event.preventDefault()
    $.when(event).done(el.siblings('.new-record').children('.track-form-fields').show())
    TrackForm.change_track_add_text()

  @change_track_add_text = ->
    if $('.track-form-group').length > 0
      $('.add_fields').text('Add another track')
    else
      $('.add_fields').text('Add a track')


