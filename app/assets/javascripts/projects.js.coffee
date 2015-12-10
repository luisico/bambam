jQuery ->
  new Filebrowser('#track-tree')

  $("#project_user_ids").select2({
    placeholder: "Add a user"
  });

  $('#create-new-project').on 'click', '#project-cancel', (event) ->
    $('#new-project').show()
    $(this).closest('form').remove()

  $('.project-attributes').on 'click', '#cancel-edit-users', (event) ->
    $('#project-users').show()
    $(this).closest('form').remove()

  $('.track-count').on 'filebrowserUpdateFileCount', (event) ->
    count = $('a.service.fi-eye').length
    $('.track-count').text("[" + count + "]")

  $('.project-js-igv').on 'click', '.igv-js-link', (event) ->
    $('.project-tracks').show()
    igvDiv = $('.igv-js')
    igvViewer = new IgvViewer()
    igvViewer.load(igvDiv[0], $(this).data('project-genome'), igvDiv.data('locus-range'))
    igvViewer.updateSearchInput(igvDiv.data('locus-path'), igvDiv.data('locus-range'))
    igvViewer.setInputIDforCapybara()

  $('.project-js-igv').on 'click', '.project-track', (event) ->
    igvDiv = $(this)
    igvViewer = new IgvViewer()
    igvViewer.addTrack(igvDiv.data('stream-url'), igvDiv.data('track-name'))
