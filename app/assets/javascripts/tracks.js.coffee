jQuery ->
  $('.share-track').on 'click', '.share-track-link', (event) ->
    $('.share-track-form').show()
    event.preventDefault()

  $('.share-track').on 'click', '.share-track-submit', (event) ->
    $('.share-track-form').hide()

  $(document).ready ->
    $('#expires_at').datepicker()

  $('#share-links').on 'click', '.show-track-link', (event) ->
    $(this).parent().parent().next().toggle()
    event.preventDefault()

  $('#share-links').on 'click', '.show-ucsc-link', (event) ->
    console.log($(this))
    $(this).parent().parent().next().next().toggle()
    event.preventDefault()
