BestInPlaceEditor.defaults.ajaxDataType = 'json'

class @BestInPlaceLocal
  @updateQueryParam: (field, attr, link) ->
    newAttr = encodeURIComponent(field.text())
    oldAttr = BestInPlaceLocal.getParameterByName(link.attr('href'), attr)
    newHref = link.attr('href').replace(attr + '=' + oldAttr, attr + '=' + newAttr)
    link.attr('href', newHref)

  @getParameterByName: (url, name) ->
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]')
    regex = new RegExp('[\\?&]' + name + '=([^&#]*)')
    results = regex.exec(url)
    if results == null then '' else results[1]

jQuery ->
  $('.best_in_place').best_in_place()

  $('.best_in_place').bind 'ajax:success', (event, data) ->
    $(this).parent().effect('highlight', {}, 1500)

  $('.best_in_place').bind 'ajax:error', (event, data) ->
    $(this).parent().effect('highlight', {color: 'red'}, 1500)
      .append("<small class='error'>" + data.responseJSON[0] + '</small>')
      .children('.error').fadeOut(10000, ->
          $(this).remove()
        )
