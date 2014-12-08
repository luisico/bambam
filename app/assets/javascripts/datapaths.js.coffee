jQuery ->
  $('#datapaths-index').on 'click', '.datapath-cancel', (event) ->
    $('#new-datapath-link').show()
    $(this).closest('form').remove()
    event.preventDefault()

class @DatapathUsers
  @applySelect2: ->
    $("#datapath_user_ids").select2({
      placeholder: "Select a user",
      allowClear: true
    });
