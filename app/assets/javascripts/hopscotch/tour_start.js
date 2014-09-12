var tour = $('div[data-tour]')

if(tour.data('tour')){
  $("#tour-start").on("click", function(){
    hopscotch.startTour(eval(tour.data('tour')));
  })
}
else {
  $("#tour-start").hide();
}
