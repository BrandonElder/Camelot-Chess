document.addEventListener("turbolinks:load", function() {
  $(function() {
    $('#arrows').click(function() {
      $('html,body').animate({

        scrollTop: $('.about-section').offset().top},
        'slow');
      return false;
      });        
   });
});
