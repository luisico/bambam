class @TrackForm
  constructor: (event) ->
    @group = $(event.target).closest('div.track-form-group')
    @objects =
      name:    @group.find('.track-name')
      fields:  @group.find('.track-form-fields')
      done:    @group.find('.done-track')
      remove:  @group.find('.remove-track')
      restore: @group.find('.restore-track')
      hidden:  @group.find('input[type=hidden]')
    @states =
      new: 'new-record'
      edit: 'edit-record'
    event.preventDefault() if event?

  edit: ->
    @group.addClass(@states['edit'])
    for object in ['fields', 'done' ]
      @show(object)
    @hide('name')

  done: ->
    @group.removeClass(@states['edit'])
    for object in ['fields', 'done' ]
      @hide(object)
    @updateName()

  restore: ->
    @show('remove')
    @hide('restore')
    @objects['name'].addClass('edit-track').removeClass('line-through no-pointer')
    @deleteTrack('no')

  delete: ->
    if @isState('new')
      @group.remove()
    else
      @show('restore')
      @hide('remove')
      @objects['name'].addClass('line-through no-pointer').removeClass('edit-track')
      @deleteTrack('yes')
      @done() if @isState('edit')
    TrackForm.change_track_add_text()

  isState: (state) ->
    @group.hasClass(@states[state])

  show: (obj) ->
    @objects[obj].show()

  hide: (obj) ->
    @objects[obj].hide()

  deleteTrack: (answer) ->
    if answer == 'yes'
      @objects['hidden'].val('1')
    else if answer == 'no'
      @objects['hidden'].val('0')

  updateName: ->
    text = @group.find("label:contains('Name')").next().val()
    @objects['name'].text(text).show()

  @addTrack: (event) ->
    el = $(event.target)
    time = new Date().getTime()
    regexp = new RegExp(el.data('id'), 'g')
    el.before(el.data('fields').replace(regexp, time))
    event.preventDefault()
    $.when(event).done(el.siblings('.new-record').find('.track-form-fields').show())
    TrackForm.change_track_add_text()

  @change_track_add_text = ->
    if $('.track-form-group').length > 0
      $('.add_fields').text('Add another track')
    else
      $('.add_fields').text('Add a track')
