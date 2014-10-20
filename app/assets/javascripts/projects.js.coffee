jQuery ->
  $('.edit-track').show()
  $('.error').closest('div.track-form-fields').show()

  $('form').on 'click', '.remove-track', (event) ->
    TrackForm.removeTrack($(this))

  $('form').on 'click', '.edit-track', (event) ->
    TrackForm.editTrack($(this))

  $('form').on 'click', '.done-track', (event) ->
    TrackForm.doneTrack($(this))

  $('form').on 'click', '.restore-track', (event) ->
    TrackForm.restoreTrack($(this))

  $('form').on 'click', '.add_fields', (event) ->
    TrackForm.addTrack($(this))

  $(document).ready ->
    TrackForm.change_track_add_text()

