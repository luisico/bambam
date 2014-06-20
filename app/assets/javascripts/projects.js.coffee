jQuery ->
  $('.track-form-group').hide()
  $('.edit-track').show()

  $('form').on 'click', '.remove-track', (event) ->
    if $(this).closest('fieldset').hasClass('new-record')
      $(this).closest('fieldset').remove()
    else
      $(this).closest('fieldset').children('div.track-form-group').children('input[type=hidden]').val('1')
      $(this).parent().siblings().find('.track-name').css('textDecoration', 'line-through')
      $(this).parent().siblings().find('.edit-track').hide()
      $(this).parent().siblings().find('.done-track').hide()
      $(this).closest('fieldset').children('div.track-form-group').hide()
      $(this).hide()
      $(this).parent().siblings().find('.restore-track').show()
      $('.update-project-tracks').show()
      event.preventDefault()

  $('form').on 'click', '.edit-track', (event) ->
    $(this).hide()
    $(this).parent().siblings().find('.done-track').show()
    $(this).closest('fieldset').children('div').show()
    $('.update-project-tracks').show()

  $('form').on 'click', '.done-track', (event) ->
    $(this).hide()
    text = $(this).closest('fieldset').children('div.track-form-group').find('input').first().val()
    $(this).parent().siblings().find('.track-name').text(text)
    $(this).parent().siblings().find('.edit-track').show()
    $(this).parent().siblings().find('.done-track').show()
    $(this).closest('fieldset').children('div').hide()

  $('form').on 'click', '.restore-track', (event) ->
    $(this).hide()
    $(this).parent().siblings().find('.track-name').css('textDecoration', 'none')
    $(this).parent().siblings().find('.track-name').show()
    $(this).parent().siblings().find('.edit-track').show()
    $(this).parent().siblings().find('.remove-track').show()
    $(this).closest('fieldset').children('div.track-form-group').children('input[type=hidden]').val('0')

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()
