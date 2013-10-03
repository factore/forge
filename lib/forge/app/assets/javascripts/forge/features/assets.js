FORGE.features.assets.reorganize = function (mod, options) {
  var config = {
    selector: '#asset-list ul li'
  }
  $.extend(config, options);
  var $assets = $(config.selector);
  
  $assets.removeClass('last');
  $.each($assets, function() {
    var index = $(this).index();
    if((index + 1) % mod === 0) {
      $(this).addClass('last');
    }
    if(index > 19) {
      $(this).fadeOut('fast');
    }
  });  
}