jQuery ->
  $('#new-datapath').on 'click', '.datapath-cancel', (event) ->
    $('#new-datapath-link').show()
    $(this).closest('form').remove()
    event.preventDefault()

  $('#datapath-list').on 'click', '.datapath-cancel', (event) ->
    $(this).closest('li').find('.edit-datapath-link').show()
    $(this).closest('li').find('.datapath-users').show()
    $(this).closest('form').remove()
    event.preventDefault()

class @DatapathUsers
  @applySelect2: ->
    $("#datapath_user_ids").select2({
      placeholder: "Select a user",
      allowClear: true
    }).on('select2-removing', (e) ->
      confirm('WARNING!!!\nRemoving this manager will permanently delete all tracks they have associated with this datapath. Are you sure you want to continue?')
    );
