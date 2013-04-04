FORGE.features.videoFeeds = {
  init: function () {
    $(".forge_submenu.video_feeds").on('click', '#pull-video-feed', function() {
      $("#thinking").fadeIn(300);
    });

  }
}