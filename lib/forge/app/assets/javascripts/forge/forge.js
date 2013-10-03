var FORGE = {
  features: {
    assets: {}
  },

  helpers: {},

  init: function() {
    $('input.datepicker').datepicker({ dateFormat: "yy-mm-dd" });
    FORGE.setupFancybox();
    FORGE.setupMediaElementJs();
    FORGE.features.assets.dialog.init();
    FORGE.features.buttons.init();
    FORGE.features.mainMenu.init();
    FORGE.features.notifications.init();
    FORGE.features.i18n.init();
    FORGE.features.help.init();
    FORGE.features.forms.init();
    FORGE.features.fileSelectWidget.init();
    FORGE.assetDrawer = new FORGE.features.assets.Drawer('#asset-drawer');
    FORGE.assetDrawer.init();
    FORGE.features.videoFeeds.init();
  },

  setupFancybox: function() {
    var setup = function() {
      $('a.fancybox').fancybox({titlePosition: 'over', overlayOpacity: 0.8, overlayColor: '#333'});
      $('a.fancybox.notitle').fancybox({titleShow: 'false', overlayOpacity: 0.8, overlayColor: '#333'});
    };
    setup();
    $(document).ajaxStop(function () { setup(); });
  },

  setupMediaElementJs: function (options) {
    $('video,audio').mediaelementplayer(options);
  },

  loadInDialog: function (url, dialogOptions) {
    var options = $.extend({width: 500, close: function() { div.remove(); }, modal: true}, dialogOptions);
    var id = new Date().getTime();
    $div = $('<div />').attr('id', id);
    $.ajax({
      url: url,
      dataType: 'HTML',
      success: function(data) {
        $div.html(data);
        $div.dialog(options);
      }
    });
  }
};
