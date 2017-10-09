
document.addEventListener("turbolinks:load", function() {
  var menuToggle = $("#js-mobile-menu").unbind();
  $("#js-navigation-menu").removeClass("show");

  menuToggle.on("click", function(e) {
    e.preventDefault();
    $('.burger-toggle').toggleClass('opened');
    if ($('.hero').hasClass('active')) {
      $('.hero').removeClass('active');  
    } else {
      $('.hero').addClass('active');
      $('.hero').removeClass('active');
    }
    if ($('.navigation-wrapper').hasClass('clear')) {
      $('.navigation-wrapper').removeClass('clear');
    }
    $("#js-navigation-menu").slideToggle(function(){
      if ($("#js-navigation-menu").is(":hidden")) {
        $("#js-navigation-menu").removeAttr("style");
      } 
    });
  }); 
}); 
