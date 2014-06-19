jQuery ->
  $('form').on 'click', '.remove-track', (event) ->
    $(this).closest('fieldset').children('div.track-form-group').children('input[type=hidden]').val('1')
    $(this).parent().siblings().find('.track-name').css('textDecoration', 'line-through')
    $(this).parent().siblings().find('.edit-track').hide()
    $(this).parent().siblings().find('.done-track').hide()
    $(this).closest('fieldset').children('div.track-form-group').hide()
    $(this).hide()
    $(this).parent().siblings().find('.restore-track').show()
    $('.update-project-tracks').show()
    event.preventDefault()

  $('.edit-track').click ->
    $(this).hide()
    $(this).parent().siblings().find('.done-track').show()
    $(this).closest('fieldset').children('div').show()
    $('.update-project-tracks').show()

  $('.done-track').click ->
    $(this).hide()
    text = $(this).closest('fieldset').children('div.track-form-group').find('input').first().val()
    $(this).parent().siblings().find('.track-name').text(text)
    $(this).parent().siblings().find('.edit-track').show()
    $(this).parent().siblings().find('.done-track').show()
    $(this).closest('fieldset').children('div').hide()

  $('.restore-track').click ->
    $(this).hide()
    $(this).parent().siblings().find('.track-name').css('textDecoration', 'none')
    $(this).parent().siblings().find('.track-name').show()
    $(this).parent().siblings().find('.edit-track').show()
    $(this).parent().siblings().find('.remove-track').show()
    $(this).closest('fieldset').children('div.track-form-group').children('input[type=hidden]').val('0')

  $('div.track-form-group').hide()
  $('.update-project-tracks').hide()
  $('.restore-track').hide()
  $('.done-track').hide()
