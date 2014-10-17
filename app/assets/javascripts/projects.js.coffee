jQuery ->
  $('.edit-track').show()
  $('.error').closest('div.track-form-fields').show()

  $('form').on 'click', '.remove-track', (event) ->
    trackFormGroup = $(this).closest('div.track-form-group')
    if trackFormGroup.hasClass('new-record')
      trackFormGroup.remove()
      event.preventDefault()
    else
      trackFormGroup.find('input[type=hidden]').val('1')
      $(this).closest('li').siblings().find('.edit-track').css('textDecoration', 'line-through')
      $(this).closest('li').siblings().find('.done-track').hide()
      trackFormGroup.children('div.track-form-fields').hide()
      $(this).hide()
      $(this).closest('li').siblings().find('.restore-track').show()
      $('.update-project-tracks').show()
      event.preventDefault()
    change_track_add_text()

  $('form').on 'click', '.edit-track', (event) ->
    $(this).closest('div.track-form-group').addClass('edit-record')
    $(this).hide()
    $(this).parent().siblings().find('.remove-track').hide()
    $(this).parent().siblings().find('.done-track').show()
    $(this).closest('div.track-form-group').children('div').show()
    $('.update-project-tracks').show()
    event.preventDefault()

  $('form').on 'click', '.done-track', (event) ->
    $(this).hide()
    $(this).closest('div.track-form-group').removeClass('edit-record')
    $(this).parent().siblings().find('.remove-track').show()
    text = $(this).closest('div.track-form-group').children('div.track-form-fields').find('input').first().val()
    $(this).parent().siblings().find('.track-name').show()
    $(this).parent().siblings().first().children().text(text)
    $(this).parent().siblings().find('.done-track').show()
    $(this).closest('div.track-form-group').children('div').hide()
    event.preventDefault()

  $('form').on 'click', '.restore-track', (event) ->
    $(this).hide()
    $(this).parent().siblings().find('.edit-track').css('textDecoration', 'none')
    $(this).parent().siblings().find('.edit-track').show()
    $(this).parent().siblings().find('.remove-track').show()
    $(this).closest('div.track-form-group').children('div.track-form-fields').children('input[type=hidden]').val('0')
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

