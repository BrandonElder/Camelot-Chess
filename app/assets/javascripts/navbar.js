/*global $*/
document.addEventListener("turbolinks:load", function() {
  var menuToggle = $("#js-mobile-menu").unbind();
  $("#js-navigation-menu").removeClass("show");
  var $path = window.location.pathname;
  menuToggle.on("click", function(e) {
    e.preventDefault();
    $('.burger-toggle').toggleClass('opened');
    if ($('.hero').hasClass('active')) {
      $('.hero').removeClass('active');  
    } else {
      $('.hero').addClass('active');
      $('.hero').removeClass('active');
    }
    
    if($('.navigation-wrapper').hasClass('clear')) {
      $('.navigation-wrapper').removeClass('clear')
      $('.navigation-wrapper').addClass('active')
    } else if($('.navigation-wrapper').hasClass('active')) {
      $('.navigation-wrapper').removeClass('active')
      $('.navigation-wrapper').addClass('clear')
    } else if($('.navigation-wrapper').hasClass('dark')) {
      $('.navigation-wrapper').removeClass('clear')
      $('.navigation-wrapper').toggleClass('dark')
    }
      
    
    /*var $path = window.location.pathname;

    if ($path == 'https://camelot-chess-brandonelder.c9users.io/messages') {
      $('.navigation-wrapper').removeClass('clear');
    } else if ($path == 'https://camelot-chess-brandonelder.c9users.io/games') {
      $('.navigation-wrapper').removeClass('clear');
    } else {
      menuToggle.on("click" , function(e) {
        e.preventDefault();
        if ($('.navigation-wrapper').hasClass('active')) {
          $('.navigation-wrapper').removeClass('active');
          $('.navigation-wrapper').addClass('clear');
        } else {
          menuToggle.on("click" , function(e) {
          e.preventDefault();
           $('.navigation-wrapper').addClass('clear');
          });
        }
      
    });
    } */
    
    $("#js-navigation-menu").slideToggle(function(){
      if ($("#js-navigation-menu").is(":hidden")) {
        $("#js-navigation-menu").removeAttr("style");
      } 
    });
    
  }); 
});
