jQuery.fn.submitOnCheck = ->
  @find('input[type=submit]').remove()
  @find('input[type=checkbox]').hide()
  @find('input[type=checkbox]').click ->
    $(this).parent('form').submit()
  this

jQuery.replaceParam = (url, name, value) ->
  link = document.createElement('a')
  link.href = url
  search = link.search

  params = $.map(search.replace(/^\?/, '').split('&'), (val, i) ->
    items = val.split('=')
    items[1] = encodeURI(value) if decodeURI(items[0]) == name
    items.join('=')
  ).join('&')

  link.search = params
  link.href
