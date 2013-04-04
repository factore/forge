APP.features.mobile = {
  // animate the main button icons on hover:
  init: function () {
    // ADD HINTS TO FORM ELEMENTS
    $('.hint').hint();

    // WATCH WINDOW WIDTH FOR NARROW
    if ($(window).width() < 300) {
      $("body").addClass('narrow');
    } else {
      $("body").removeClass('narrow');
    }

    // MAIN NAVIGATION
    $('#head').on('click', '.navigation', function () {
      $that = $(this);
      $('#navigation')
        .css('top', $('#head').height() + 30) // SET NAVIGATION POSITION (#head height + padding and border)
        .slideToggle(200, function () {
          if ($that.hasClass('down')) {
            $that.removeClass('down');
          } else {
            $that.addClass('down');
          }
        });
      return false;
    });

    // POST INDEX
    $('#posts').on('click', '.post', function () {
      window.location = $(this).attr('data-url');
      return false;
    });

  }
};
