jQuery ->
  $('.edit-track').show()

  $('.best_in_place').best_in_place()
  $('.best_in_place').bind 'ajax:success', ->
    $(this).closest('#project-name').effect("highlight", {}, 1500)
  $('.best_in_place').bind 'ajax:error', (event, data) ->
    $(this).closest('#project-name').effect("highlight", {color: 'red'}, 3000)
      .append("<h3 class='bip-error'>"+$(data)[0].responseText+"</h3>")
      .children('.bip-error').fadeOut(3000)

  Fancytree.applyFancytree()

  $('.error').closest('div.track-form-fields').show()

  $('form').on 'click', '.remove-track', (event) ->
    new TrackForm(event).delete()

  $('form').on 'click', '.edit-track', (event) ->
    new TrackForm(event).edit()

  $('form').on 'click', '.done-track', (event) ->
    new TrackForm(event).done()

  $('form').on 'click', '.restore-track', (event) ->
    new TrackForm(event).restore()

  $('form').on 'click', '.add_fields', (event) ->
    TrackForm.addTrack(event)

  $(document).ready ->
    TrackForm.change_track_add_text()

  $("#project_user_ids").select2({
    placeholder: "Add a user"
  });

  $('#create-new-project').on 'click', '#project-cancel', (event) ->
    $('#new-project').show()
    $(this).closest('form').remove()

  $('.project-attributes').on 'click', '#cancel-edit-users', (event) ->
    $('#project-users').show()
    $(this).closest('form').remove()
