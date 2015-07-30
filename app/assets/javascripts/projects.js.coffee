jQuery ->
  new Filebrowser('#track-tree')

  $("#project_user_ids").select2({
    placeholder: "Add a user"
  });

  $('#create-new-project').on 'click', '#project-cancel', (event) ->
    $('#new-project').show()
    $(this).closest('form').remove()

  $('.project-attributes').on 'click', '#cancel-edit-users', (event) ->
    $('#project-users').show()
    $(this).closest('form').remove()

  $('.track-count').on 'filebrowserUpdateFileCount', (event) ->
    count = $('a.service.fi-eye').length
    $('.track-count').text("[" + count + "]")
