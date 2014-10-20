class @TrackForm
  @removeTrack: (el) ->
    trackFormGroup = el.closest('div.track-form-group')
    inlineList = el.closest('li').siblings()
    if trackFormGroup.hasClass('new-record')
      trackFormGroup.remove()
    else if trackFormGroup.hasClass('edit-record')
      trackFormGroup.find('input[type=hidden]').val('1')
      inlineList.find('.edit-track').addClass('line-through')
      inlineList.find('.edit-track').show()
      inlineList.find('.done-track').hide()
      trackFormGroup.removeClass('edit-record')
      trackFormGroup.children('div.track-form-fields').hide()
      el.hide()
      inlineList.find('.restore-track').show()
    else
      trackFormGroup.find('input[type=hidden]').val('1')
      inlineList.find('.edit-track').addClass('line-through')
      el.hide()
      inlineList.find('.restore-track').show()
    event.preventDefault()
    TrackForm.change_track_add_text()

  @editTrack: (el) ->
    trackFormGroup = el.closest('div.track-form-group')
    inlineList = el.closest('li').siblings()
    trackFormGroup.addClass('edit-record')
    el.hide()
    inlineList.find('.done-track').show()
    trackFormGroup.children('div').show()
    event.preventDefault()

  @doneTrack: (el) ->
    trackFormGroup = el.closest('div.track-form-group')
    inlineList = el.closest('li').siblings()
    el.hide()
    trackFormGroup.removeClass('edit-record')
    inlineList.find('.remove-track').show()
    text = trackFormGroup.children('div.track-form-fields').find('input').first().val()
    inlineList.find('.track-name').show()
    inlineList.first().children().text(text)
    inlineList.find('.done-track').show()
    trackFormGroup.children('div').hide()
    event.preventDefault()

  @restoreTrack: (el) ->
    trackFormGroup = el.closest('div.track-form-group')
    inlineList = el.closest('li').siblings()
    el.hide()
    inlineList.find('.edit-track').removeClass('line-through')
    inlineList.find('.edit-track').show()
    inlineList.find('.remove-track').show()
    trackFormGroup.children('div.track-form-fields').children('input[type=hidden]').val('0')
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


