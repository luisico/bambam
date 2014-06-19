$(function(){
  $(".igv.service").on("click", function(event){
    event.preventDefault();

    var port = $(this).data('port');
    var command = $(this).data('command');
    var params = $(this).data('params');
    igv.igvRequest(port, command, params);
  });
});
