class @ShareLink
  @showForm: (code, id='') ->
    if id == ''
      selector = '#create-share-links'
    else
      selector = '#share_link_' + id

    $(selector).append(code)
    ShareLink.datepicker()

  @datepicker: ->
    $('#share_link_expires_at').datepicker({ dateFormat: "'Expires:' d, M yy" })
