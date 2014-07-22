jQuery ->
  $('.edit-track').show()
  $('.error').closest('div.track-form-fields').show()

  $('form').on 'click', '.remove-track', (event) ->
    if $(this).closest('div.track-form-group').hasClass('new-record')
      $(this).closest('div.track-form-group').remove()
      if $(".track-form-group").length == 0
        $('.add_fields').text('Add Track')
    else
      $(this).closest('div.track-form-group').children('div.track-form-fields').children('input[type=hidden]').val('1')
      $(this).closest('li').siblings().first().css('textDecoration', 'line-through')
      $(this).closest('li').siblings().find('.done-track').hide()
      $(this).closest('div.track-form-group').children('div.track-form-fields').hide()
      $(this).hide()
      $(this).closest('li').siblings().find('.restore-track').show()
      $('.update-project-tracks').show()
      event.preventDefault()

  $('form').on 'click', '.edit-track', (event) ->
    $(this).closest('div.track-form-group').addClass('edit-record')
    $(this).hide()
    $(this).parent().siblings().find('.remove-track').hide()
    $(this).parent().siblings().find('.done-track').show()
    $(this).closest('div.track-form-group').children('div').show()
    $('.update-project-tracks').show()

  $('form').on 'click', '.done-track', (event) ->
    $(this).hide()
    $(this).closest('div.track-form-group').removeClass('edit-record')
    $(this).parent().siblings().find('.remove-track').show()
    text = $(this).closest('div.track-form-group').children('div.track-form-fields').find('input').first().val()
    $(this).parent().siblings().find('.track-name').show()
    $(this).parent().siblings().first().children().text(text)
    $(this).parent().siblings().find('.done-track').show()
    $(this).closest('div.track-form-group').children('div').hide()

  $('form').on 'click', '.restore-track', (event) ->
    $(this).hide()
    $(this).parent().siblings().first().css('textDecoration', 'none')
    $(this).parent().siblings().find('.edit-track').show()
    $(this).parent().siblings().find('.remove-track').show()
    $(this).closest('div.track-form-group').children('div.track-form-fields').children('input[type=hidden]').val('0')

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()
    $.when(event).done($(this).siblings('.new-record').children('.track-form-fields').show())
    $(this).text('Add another track')

  $(document).ready ->
    if $(".track-form-group").length > 0
      $('.add_fields').text('Add another track')
