//= require jquery.idle-timer
//= require_self

$(function() {
  $.idleTimer(300000);
  $(document).bind('idle.idleTimer', function() {
    document.location = '/';
  });
})