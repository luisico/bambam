$('.group-by')
  .on 'click', '.by-icon', (event) ->
    $(this).toggleClass('by-open').next('.by-items').toggle()

  .on 'click', '.by-show-all', (event) ->
    $('.by-items').each ->
      $(this).show()
    $('.by-icon').each ->
      $(this).toggleClass('by-open') unless $(this).hasClass('by-open')

  .on 'click', '.by-hide-all', (event) ->
    $('.by-items').each ->
      $(this).hide()
    $('.by-icon').each ->
      $(this).removeClass('by-open')
