var APP = {
  features: {},

  init: function() {
    $('html').removeClass('noscript');

    APP.dispatcher.initialize();
  }
}
