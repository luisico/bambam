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

  @create: (element, code) ->
    $(element).append(code)
    $(element).children().last().effect("highlight", {}, 1500)
    ShareLink.clipboard($(element).children().last())

  @clipboard: (element) ->
    element = element.find('i.copy-to-clipboard')
    element.bind "click", ->
      copy_to_clipboard this
      return
    $('#no-share-link').remove()
