$(function(){
  $(".copy-to-clipboard").on("click", function(){
    id = $(this).data('clipboard-id');
    text = $("#" + id).text();
    window.prompt("Press Ctrl-C or Cmd-C to copy to clipboard", text);
  });
});
