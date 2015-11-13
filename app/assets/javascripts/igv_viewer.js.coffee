class @IgvViewer
  constructor: (selector) ->
    @igvJS = $(selector)
    @load()
    @updateSearchInput()
    @setInputIDforCapybara()

  load: ->
    div = @igvJS[0]
    options =
      showNavigation: true
      genome: $.trim($('.genome').text())
      locus: @igvJS.data('track-locus')
      tracks: [ {
        url: RAILS_RELATIVE_URL_ROOT + @igvJS.data('igv-url')
        label: 'genericTrack'
        type: 'bam'
      } ]
    igv.createBrowser div, options

  updateSearchInput: ->
    tracks_user_id = @igvJS.data('tracks-user-id')
    existing_locus = @igvJS.data('track-locus')
    $(igv.browser.div).on 'click input', (event) ->
      current_locus = $('.igvNavigationSearchInput').val()
      unless current_locus == existing_locus
        $.ajax
          type: "PATCH"
          dataType: "json"
          url: RAILS_RELATIVE_URL_ROOT + '/tracks_users/' + tracks_user_id
          data: {tracks_user: {locus: current_locus}}
        existing_locus = current_locus

  setInputIDforCapybara: ->
    $('.igvNavigationSearchInput').attr("id", "igv-js-search-input")
