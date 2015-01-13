class @Fancytree
  @applyFancytree: ->
    $('#track-tree').fancytree {
    source:
      url: "/tracks/browser"
    checkbox: true
    select: (event, data) ->
      node = data.node
      console.log(node.title)
    }

    $("form").submit ->
      $("#track-tree").fancytree("getTree").generateFormElements()
      alert("POST data:\n" + jQuery.param($(this).serializeArray()))

