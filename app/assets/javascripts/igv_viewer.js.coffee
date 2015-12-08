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
      locus: @igvJS.data('locus-range')
    igv.createBrowser div, options
    config = {
      url: @igvJS.data('igv-url')
      label: $.trim($('.track-name').text())
      }
    bamTrack = new igv.BAMTrack(config)
    bamTrack.alignmentShading = 'strand'
    igv.browser.addTrack(bamTrack)

  updateSearchInput: ->
    locus_path = @igvJS.data('locus-path')
    existing_range = @igvJS.data('locus-range')
    $(igv.browser.div).on 'click input', (event) ->
      current_range = $('.igvNavigationSearchInput').val()
      unless current_range == existing_range
        $.ajax
          type: "PATCH"
          dataType: "json"
          url: locus_path
          data: {locus: {range: current_range}}
        existing_range = current_range

  setInputIDforCapybara: ->
    $('.igvNavigationSearchInput').attr("id", "igv-js-search-input")
