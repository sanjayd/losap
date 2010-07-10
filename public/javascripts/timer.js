$(function() {
  $.idleTimer(300000);
  $(document).bind('idle.idleTimer', function() {
    document.location = '/';
  });
})