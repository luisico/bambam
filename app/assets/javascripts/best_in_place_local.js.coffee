BestInPlaceEditor.defaults.ajaxDataType = 'json'

jQuery ->
  $('.best_in_place').best_in_place()

  $('.best_in_place').bind 'ajax:success', (event, data) ->
    $(this).parent().effect('highlight', {}, 1500)

  $('.best_in_place').bind 'ajax:error', (event, data) ->
    errorMessage = if data.responseJSON then data.responseJSON[0] else "File system error. Changes not saved."
    $(this).parent().effect('highlight', {color: 'red'}, 1500)
      .append("<small class='error'>" + errorMessage + '</small>')
      .children('.error').fadeOut(10000, ->
          $(this).remove()
        )
