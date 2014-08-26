jQuery ->
  $('#share-links').on 'click', '.show-track-link', (event) ->
    $(this).parent().parent().next().toggle()
    event.preventDefault()

  $('#share-links').on 'click', '.show-ucsc-link', (event) ->
    $(this).parent().parent().next().next().toggle()
    event.preventDefault()

  $(document).ready ->
    $('#share-links').find('.expired').parent().hide()

  $('.share-track').on 'click', '.show-expired-share-links', (event) ->
    $('#share-links').find('.expired').parent().show()
    $(this).text('| hide expired links')
    $(this).addClass('hide-expired-share-links').removeClass('show-expired-share-links')
    event.preventDefault()

  $('.share-track').on 'click', '.hide-expired-share-links', (event) ->
    $('#share-links').find('.expired').parent().hide()
    $(this).text('| show expired links')
    $(this).addClass('show-expired-share-links').removeClass('hide-expired-share-links')
    event.preventDefault()

  $('.share-track').on 'click', '.share-track-cancel', (event) ->
    if $(this).closest('form').hasClass('edit_share_link')
      $(this).closest('form').siblings().first().children().find('.edit-share-link-link').show()
      $(this).closest('form').remove()
      event.preventDefault()
    else
      $(this).closest('form').remove()
      $('#new_link').show()
      event.preventDefault()
