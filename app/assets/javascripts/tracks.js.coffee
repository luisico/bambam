jQuery ->
  $('.best_in_place[data-bip-object="track"]').bind 'ajax:success', ->
    igv = $('a.service.fi-eye')
    igv.attr('href', $.replaceParam(igv.attr('href'), $(this).data('bipAttribute'), $(this).data('bipValue')))

  $('#share-links-list').on 'click', '.show-track-link', (event) ->
    $(this).parent().parent().next().toggle()
    event.preventDefault()

  $('#share-links-list').on 'click', '.show-ucsc-link', (event) ->
    $(this).parent().parent().next().next().toggle()
    event.preventDefault()

  $(document).ready ->
    $('#share-links-list').find('.expired').siblings().find('a.edit-share-link-link').text('renew')
    $('#share-links-list').find('.expired').parent().hide()

  $('.share-track').on 'click', '.show-expired-share-links', (event) ->
    $('#share-links-list').find('.expired').parent().show()
    $(this).text('hide expired links')
    $(this).addClass('hide-expired-share-links').removeClass('show-expired-share-links')
    event.preventDefault()

  $('.share-track').on 'click', '.hide-expired-share-links', (event) ->
    $('#share-links-list').find('.expired').parent().hide()
    $(this).text('show expired links')
    $(this).addClass('show-expired-share-links').removeClass('hide-expired-share-links')
    event.preventDefault()

  $('.share-track').on 'click', '.share-track-cancel', (event) ->
    if $(this).closest('form').hasClass('edit_share_link')
      $(this).closest('form').siblings().first().children().find('.edit-share-link-link').show()
      $(this).closest('.share-link').removeClass('share-link-box')
      $(this).closest('form').remove()
      event.preventDefault()
    else
      $(this).closest('form').remove()
      $('#new_link').show()
      event.preventDefault()

  $('.share-track').on 'click', '.one-week', (event) ->
    now = new Date()
    now.setDate(now.getDate() + 7)
    time = format_date(now)
    $(this).closest('form').find('#share_link_expires_at').val(time)
    event.preventDefault()

  $('.share-track').on 'click', '.one-month', (event) ->
    now = new Date()
    now.setMonth(now.getMonth() + 1)
    time = format_date(now)
    $(this).closest('form').find('#share_link_expires_at').val(time)
    event.preventDefault()

  $('.share-track').on 'click', '.one-year', (event) ->
    now = new Date()
    now.setFullYear(now.getFullYear() + 1)
    time = format_date(now)
    $(this).closest('form').find('#share_link_expires_at').val(time)
    event.preventDefault()

  $('#track-download-links').on 'click', '.igv-js-link', (event) ->
    new IgvViewer('.igv-js')

  $('.igv-js').on 'click input', '.igvNavigationSearchInput', (event) ->
    locus = $(this).val()
    $.ajax
      type: "PATCH"
      dataType: "json"
      url: RAILS_RELATIVE_URL_ROOT + '/tracks_users/' + $('.igv-js').data('tracks-user-id')
      data: {tracks_user: {locus: locus}}

  format_date = (time) ->
    m_names = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");

    curr_date = time.getDate();
    curr_month = time.getMonth();
    curr_year = time.getFullYear();
    return ("Expires: " + curr_date + ", " + m_names[curr_month] + " " + curr_year);
