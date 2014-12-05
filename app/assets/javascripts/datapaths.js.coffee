jQuery ->
  DatapathUsers.applySelect2()

class @DatapathUsers
  @applySelect2: ->
    $("#datapath_user_ids").select2({
      placeholder: "Select a user",
      allowClear: true
    });
