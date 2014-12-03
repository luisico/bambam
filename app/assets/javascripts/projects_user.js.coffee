jQuery ->
  $('.edit_projects_user').submitOnCheck()
  $('#project-users-read-only').find('label').text('restore access')

class @ProjectUserLists
  @regularUserCount: ->
    count = $('#project-users-regular').children().length
    $('#regular-users').html("<i></i>Users [" + count + "]")

  @readOnlyUserCount: ->
    count = $('#project-users-read-only').children().length
    $('#read-only-users').html("<i></i>Read-Only Users [" + count + "]")

  @updateCount: ->
    ProjectUserLists.regularUserCount()
    ProjectUserLists.readOnlyUserCount()
