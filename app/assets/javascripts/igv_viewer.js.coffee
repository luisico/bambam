class @IgvViewer
  constructor: (selector) ->
    @igvJS = $(selector)
    @load()

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
