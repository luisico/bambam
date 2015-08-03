jQuery ->
  $('[data-excerpt]').on 'click', (event) ->
    if $(this).data('excerpt') == true
      $(this).text($(this).data('long'))
      $(this).data('excerpt', false)
    else
      $(this).text($(this).data('short'))
      $(this).data('excerpt', true)
