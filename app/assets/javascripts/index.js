$(function() {
  $('#open-team').click(function() {
    $('html,body').animate({
      scrollTop: $(".about-section").offset().top},
      'slow');
    return false;
    });        
 });