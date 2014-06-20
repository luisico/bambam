jQuery ->
  $('.track-form-fields').hide()
  $('.edit-track').show()

  $('form').on 'click', '.remove-track', (event) ->
    if $(this).closest('div.track-form-group').hasClass('new-record')
      $(this).closest('div.track-form-group').remove()
    else
      $(this).closest('div.track-form-group').children('div.track-form-fields').children('input[type=hidden]').val('1')
      $(this).parent().siblings().find('.track-name').css('textDecoration', 'line-through')
      $(this).parent().siblings().find('.edit-track').hide()
      $(this).parent().siblings().find('.done-track').hide()
      $(this).closest('div.track-form-group').children('div.track-form-fields').hide()
      $(this).hide()
      $(this).parent().siblings().find('.restore-track').show()
      $('.update-project-tracks').show()
      event.preventDefault()

  $('form').on 'click', '.edit-track', (event) ->
    console.log($(this))
    $(this).hide()
    $(this).parent().siblings().find('.done-track').show()
    $(this).closest('div.track-form-group').children('div').show()
    $('.update-project-tracks').show()

  $('form').on 'click', '.done-track', (event) ->
    $(this).hide()
    text = $(this).closest('div.track-form-group').children('div.track-form-fields').find('input').first().val()
    $(this).parent().siblings().find('.track-name').text(text)
    $(this).parent().siblings().find('.edit-track').show()
    $(this).parent().siblings().find('.done-track').show()
    $(this).closest('div.track-form-group').children('div').hide()

  $('form').on 'click', '.restore-track', (event) ->
    $(this).hide()
    $(this).parent().siblings().find('.track-name').css('textDecoration', 'none')
    $(this).parent().siblings().find('.track-name').show()
    $(this).parent().siblings().find('.edit-track').show()
    $(this).parent().siblings().find('.remove-track').show()
    $(this).closest('div.track-form-group').children('div.track-form-fields').children('input[type=hidden]').val('0')

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()
