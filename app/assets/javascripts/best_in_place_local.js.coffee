BestInPlaceEditor.defaults.ajaxDataType = 'json'

class @BestInPlaceLocal
  @updateQueryParam: (field, attr, link) ->
    newAttr = field.text()
    oldAttr = field.data(attr)
    newHref = link.attr('href').replace(attr + '=' + oldAttr, attr + '=' + newAttr)
    link.attr('href', newHref)
    field.data(attr, newAttr)

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
