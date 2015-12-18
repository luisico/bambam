class @IgvViewer
  load: (div, reference, locus, fastaUrl)->
    options =
      showNavigation: true
      locus: locus
    if fastaUrl
      options['reference'] = reference
    else
      options['genome'] = reference
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
