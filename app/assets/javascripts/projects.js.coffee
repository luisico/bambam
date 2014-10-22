jQuery ->
  $('.edit-track').show()
  $('.error').closest('div.track-form-fields').show()

  $('form').on 'click', '.remove-track', (event) ->
    TrackForm.removeTrack($(this))

  $('form').on 'click', '.edit-track', (event) ->
    tf = new TrackForm($(this))
    tf.edit(event)

  $('form').on 'click', '.done-track', (event) ->
    tf = new TrackForm($(this))
    tf.done(event)

  $('form').on 'click', '.restore-track', (event) ->
    tf = new TrackForm($(this))
    tf.restore(event)

  $('form').on 'click', '.add_fields', (event) ->
    TrackForm.addTrack($(this))

  $(document).ready ->
    TrackForm.change_track_add_text()

