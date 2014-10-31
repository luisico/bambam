jQuery ->
  $("#project_ids").select2({
    placeholder: "Select a project"
  });

  $("#user_group_ids").select2({
    placeholder: "Select a group"
  });

  $('[name="user[group_ids][]"]').first().next().hide()
