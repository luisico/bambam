class @IgvViewer
  show: ->
    div = $('.igv-js')[0]
    options =
      showNavigation: true
      genome: $.trim($('.genome').text())
      tracks: [ {
        url: RAILS_RELATIVE_URL_ROOT + $('.igv-js').data('igv-url')
        label: 'genericTrack'
        type: 'bam'
      } ]
    igv.createBrowser div, options
