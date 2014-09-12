$(function(){
  $(".copy-to-clipboard").on("click", function(){
    copy_to_clipboard(this);
  });
});

  var copy_to_clipboard = function(el) {
    id = "#" + $(el).data('clipboard-id');
    text = $(el).siblings(id).text();
    window.prompt("Press Ctrl-C or Cmd-C to copy to clipboard", text);
  }
