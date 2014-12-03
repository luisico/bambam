jQuery.fn.submitOnCheck = ->
  @find('input[type=submit]').remove()
  @find('input[type=checkbox]').hide()
  @find('input[type=checkbox]').click ->
    $(this).parent('form').submit()
  this

jQuery ->
  $('.edit_projects_user').submitOnCheck()

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
