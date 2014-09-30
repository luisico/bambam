jQuery ->
  $('.truncated').on 'click', (event) ->
    if $(this).data('truncated') == true
      $(this).text($(this).data('long'))
      $(this).data('truncated', false)
    else
      $(this).text($(this).data('short'))
      $(this).data('truncated', true)
