jQuery ->
  $('#share-links').on 'click', '.show-track-link', (event) ->
    $(this).parent().parent().next().toggle()
    event.preventDefault()

  $('#share-links').on 'click', '.show-ucsc-link', (event) ->
    $(this).parent().parent().next().next().toggle()
    event.preventDefault()
