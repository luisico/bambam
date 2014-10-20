jQuery ->
  $('.edit-track').show()
  $('.error').closest('div.track-form-fields').show()

  $('form').on 'click', '.remove-track', (event) ->
    trackFormGroup = $(this).closest('div.track-form-group')
    inlineList = $(this).closest('li').siblings()
    if trackFormGroup.hasClass('new-record')
      trackFormGroup.remove()
    else if trackFormGroup.hasClass('edit-record')
      trackFormGroup.find('input[type=hidden]').val('1')
      inlineList.find('.edit-track').addClass('line-through')
      inlineList.find('.edit-track').show()
      inlineList.find('.done-track').hide()
      trackFormGroup.removeClass('edit-record')
      trackFormGroup.children('div.track-form-fields').hide()
      $(this).hide()
      inlineList.find('.restore-track').show()
    else
      trackFormGroup.find('input[type=hidden]').val('1')
      inlineList.find('.edit-track').addClass('line-through')
      $(this).hide()
      inlineList.find('.restore-track').show()
    event.preventDefault()
    change_track_add_text()

  $('form').on 'click', '.edit-track', (event) ->
    trackFormGroup = $(this).closest('div.track-form-group')
    inlineList = $(this).closest('li').siblings()
    trackFormGroup.addClass('edit-record')
    $(this).hide()
    inlineList.find('.done-track').show()
    trackFormGroup.children('div').show()
    event.preventDefault()

  $('form').on 'click', '.done-track', (event) ->
    trackFormGroup = $(this).closest('div.track-form-group')
    inlineList = $(this).closest('li').siblings()
    $(this).hide()
    trackFormGroup.removeClass('edit-record')
    inlineList.find('.remove-track').show()
    text = trackFormGroup.children('div.track-form-fields').find('input').first().val()
    inlineList.find('.track-name').show()
    inlineList.first().children().text(text)
    inlineList.find('.done-track').show()
    trackFormGroup.children('div').hide()
    event.preventDefault()

  $('form').on 'click', '.restore-track', (event) ->
    trackFormGroup = $(this).closest('div.track-form-group')
    inlineList = $(this).closest('li').siblings()
    $(this).hide()
    inlineList.find('.edit-track').removeClass('line-through')
    inlineList.find('.edit-track').show()
    inlineList.find('.remove-track').show()
    trackFormGroup.children('div.track-form-fields').children('input[type=hidden]').val('0')
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()
    $.when(event).done($(this).siblings('.new-record').children('.track-form-fields').show())
    change_track_add_text()

  change_track_add_text = ->
    if $('.track-form-group').length > 0
      $('.add_fields').text('Add another track')
    else
      $('.add_fields').text('Add a track')

  $(document).ready ->
    change_track_add_text()

