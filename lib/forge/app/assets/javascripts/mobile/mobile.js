APP.features.mobile = {
  // animate the main button icons on hover:
  init: function () {
    $('.hint').hint();

    // // mobile width
    // if ($(window).width() < 300) {
    //   $("body").addClass('narrow');
    // } else {
    //   $("body").removeClass('narrow');
    // }

    $('#head').on('click', '.navigation', function () {
      $that = $(this);
      $('#navigation').slideToggle(200, function () {
        if ($that.hasClass('down')) {
          $that.removeClass('down');
        } else {
          $that.addClass('down');
        }
      });
      return false;
    });
  }
};
