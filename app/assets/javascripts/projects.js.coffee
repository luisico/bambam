jQuery ->
  Fancytree.applyFancytree()

  $("#project_user_ids").select2({
    placeholder: "Add a user"
  });

  $('#create-new-project').on 'click', '#project-cancel', (event) ->
    $('#new-project').show()
    $(this).closest('form').remove()

  $('.project-attributes').on 'click', '#cancel-edit-users', (event) ->
    $('#project-users').show()
    $(this).closest('form').remove()

  $('.projects-index').on 'click', '.clear-projects-filter', (event) ->
    $('#projects_filter').val('')

class @Project
  @updateTracksCount: ->
    count = $('a.service.fi-eye').length
    $('.track-count').text("[" + count + "]")
