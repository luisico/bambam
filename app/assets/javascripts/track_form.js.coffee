class @TrackForm
  constructor: (el, event) ->
    @group = TrackForm.findGroup(el)

  @findGroup: (el) ->
    $(el).closest('div.track-form-group')

  edit: (event) ->
    @toggleEditBox()
    event.preventDefault() if event?

  done: (event) ->
    @toggleEditBox()
    @updateName()
    event.preventDefault() if event?

  restore: (event) ->
    @toggleDeleteRestore()
    event.preventDefault() if event?

  delete: (event) ->
    if @group.hasClass('new-record')
      @group.remove()
    else if @group.hasClass('edit-record')
      @toggleDeleteRestore()
      @toggleEditBox()
    else
      @toggleDeleteRestore()
    event.preventDefault() if event?
    TrackForm.change_track_add_text()

  findTrack: ->
    @group.find('.track-name')

  toggleEditBox: ->
    @group.toggleClass('edit-record')
    @findTrack().toggle()
    @group.find('.track-form-fields').toggle()
    @actions().find('.done-track').toggle()

  toggleDeleteRestore: ->
    @group.find('.remove-track').toggle()
    @group.find('.restore-track').toggle()
    @findTrack().toggleClass('line-through edit-track no-pointer')
    @toggleHiddenValue()

  toggleHiddenValue: ->
    hiddenValueElement = @group.find('input[type=hidden]')
    if hiddenValueElement.val() == '1'
      hiddenValueElement.val('0')
    else
      hiddenValueElement.val('1')

  updateName: ->
    text = @group.find("label:contains('Name')").next().val()
    @findTrack().text(text)

  actions: ->
    @group.find('.inline-list')



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
