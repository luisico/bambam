jQuery ->
  $('.share-track').on 'click', '.share-track-link', (event) ->
    $('.share-track-form').show()
    event.preventDefault()

  $('.share-track').on 'click', '.share-track-submit', (event) ->
    $('.share-track-form').hide()

  $(document).ready ->
    $('#expires_at').datepicker()
