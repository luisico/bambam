jQuery ->
  $('[data-excerpt]').on 'click', (event) ->
    if $(this).data('excerpt') == "short"
      $(this).text($(this).data('excerpt-long'))
      $(this).data('excerpt', "long")
    else
      $(this).text($(this).data('excerpt-short'))
      $(this).data('excerpt', "short")
