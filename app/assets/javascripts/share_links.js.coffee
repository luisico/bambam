class @ShareLink
  @showForm: (code, id='') ->
    if id == ''
      selector = '#create-share-links'
      box_selector = '.new_share_link'
    else
      selector = '#share_link_' + id
      box_selector = selector

    $(selector).append(code)
    ShareLink.datepicker()
    ShareLink.addBox(box_selector)

  @datepicker: ->
    $('#share_link_expires_at').datepicker({ dateFormat: "'Expires:' d, M yy" })

  @addBox: (selector) ->
    $(selector).addClass('share-link-box')
