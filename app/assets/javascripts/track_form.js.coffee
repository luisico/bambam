class @TrackForm
  constructor: (event) ->
    @group = $(event.target).closest('div.track-form-group')
    @objects =
      name:    @group.find('.track-name')
      fields:  @group.find('.track-form-fields')
      done:    @group.find('.done-track')
      remove:  @group.find('.remove-track')
      restore: @group.find('.restore-track')
    @states =
      new: 'new-record'
      edit: 'edit-record'
    event.preventDefault() if event?

  edit: ->
    @toggleEditState()

  done: ->
    @toggleEditState()
    @updateName()

  restore: ->
    @toggleDeleteState()

  delete: ->
    if @isState('new')
      @group.remove()
    else
      @toggleDeleteState()
      @toggleEditState() if @isState('edit')
    TrackForm.change_track_add_text()

  isState: (state) ->
    @group.hasClass(@states[state])

  toggleState: (state) ->
    @group.toggleClass(@states[state])

  toggle: (obj) ->
    @objects[obj].toggle()

  toggleEditState: ->
    @toggleState('edit')
    @toggle('name')
    @toggle('fields')
    @toggle('done')

  toggleDeleteState: ->
    @toggle('restore')
    @toggle('remove')
    @toggleEditLink()
    @toggleRemoveValue()

  toggleRemoveValue: ->
    el = @group.find('input[type=hidden]')
    el.val(if el.val() == '1' then '0' else '1')

  toggleEditLink: ->
    @objects['name'].toggleClass('line-through edit-track no-pointer')

  updateName: ->
    text = @group.find("label:contains('Name')").next().val()
    @objects['name'].text(text)

  @addTrack: (el) ->
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
