/*global $*/
document.addEventListener("turbolinks:load", function() {
  var menuToggle = $("#js-mobile-menu").off();
  $("#js-navigation-menu").removeClass("show");
  menuToggle.on("click", function(e) {
    e.preventDefault();
    $('.burger-toggle').toggleClass('opened'); 
    if($('.navigation-wrapper').hasClass('clear')) {
      $('.hero').css({"opacity":"0.7", "transition":"opacity 0.4s ease"});
      $('.navigation-wrapper').css({"background-color":"darkslategrey", 
                            "transition":"background-color 0.1s ease"});
      $('.navigation-wrapper').removeClass('clear');
      $('.navigation-wrapper').addClass('active');
    } else if($('.navigation-wrapper').hasClass('active')) {
      $('.hero').css({"opacity":"1.0"});
      $('.navigation-wrapper').css({"background-color":"rgba(0,0,0,0.06)", 
                              "transition":"background-color 1.0s ease"});
      $('.navigation-wrapper').removeClass('active');
      $('.navigation-wrapper').addClass('clear');
    } else if($('.navigation-wrapper').hasClass('dark')) {
      $('.navigation-wrapper').toggleClass('dark')
    }
    
    $("#js-navigation-menu").slideToggle(function(){
      if ($("#js-navigation-menu").is(":hidden")) {
        $("#js-navigation-menu").removeAttr("style");
      } 
    });
  }); 
});
