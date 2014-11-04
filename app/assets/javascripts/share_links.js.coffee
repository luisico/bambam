class @ShareLink
  @showForm: (code, id='') ->
    if id == ''
      selector = '#create-share-links'
      box_selector = '.new_share_link'
    else
      selector = '#share_link_' + id
      box_selector = selector

    $(selector).append(code)
    ShareLink.datepicker(box_selector)
    ShareLink.addBox(box_selector)

  @datepicker: (selector) ->
    $(selector).find('#share_link_expires_at').datepicker({ dateFormat: "'Expires:' d, M yy" })

  @addBox: (selector) ->
    $(selector).addClass('share-link-box')

  @create: (element, code) ->
    $(element).append(code)
    new_element = $(element).children().last()
    ShareLink.highlight(new_element)
    ShareLink.clipboard(new_element)
    $('#no-share-link').remove()
    ShareLink.orderLinks()

  @update: (element, code) ->
    $(element).replaceWith(code)
    ShareLink.highlight(element)
    ShareLink.clipboard(element)
    ShareLink.orderLinks()

  @clipboard: (element) ->
    $(element).find('i.copy-to-clipboard').bind "click", ->
      copy_to_clipboard this
      return

  @highlight: (element) ->
    $(element).effect("highlight", {}, 1500)

  @orderLinks: ->
    share_links = $('#share-links-list')
    share_links_divs = share_links.children('div.share-link')

    share_links_divs.sort((a, b) ->
      new Date($(a).attr("data-expires_at")) < new Date($(b).attr("data-expires_at"))
      ).each ->
        share_links.prepend this
        return
