class @IgvViewer
  load: (div, genome, locus)->
    options =
      showNavigation: true
      genome: genome
      locus: locus
    igv.createBrowser div, options

  addTrack: (url, name) ->
    config = {
      url: url
      label: name
      }
    bamTrack = new igv.BAMTrack(config)
    bamTrack.alignmentShading = 'strand'
    igv.browser.addTrack(bamTrack)

  updateSearchInput: (tracksUserPath, existingLocus) ->
    $(igv.browser.div).on 'click input', (event) ->
      currentLocus = $('.igvNavigationSearchInput').val()
      unless currentLocus == existingLocus
        $.ajax
          type: "PATCH"
          dataType: "json"
          url: tracksUserPath
          data: {locus: {range: currentLocus}}
        existingLocus = currentLocus

  setInputIDforCapybara: ->
    $('.igvNavigationSearchInput').attr("id", "igv-js-search-input")
