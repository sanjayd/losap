$(function() {
  $('#accordion').accordion();
  $('#admintabs').tabs({cookie: {expires: 1}});

  $('#reportform')
    .bind('ajax:beforeSend', function(request) {
      $('#reportpending').css('visibility', 'visible');
    })
    .bind('ajax:success', function(data) {
      $('#reportpending').css('visibility', 'hidden');
    });

  $('#monthly_report_form').submit(function () {
    this.action = $(this).attr('data-url') + '/' + $('#month').val();
  })
  
  $('#annual_report_form').submit(function() {
    this.action = $(this).attr('data-url') + '/' + $('#year').val();
  })
    
  $("#unlock_month_form").submit(unlock_month_form);
});

function unlock_month_form() {
  var form = $('#unlock_month_form');
  var action = form.attr('action');
  form.attr('action', action + '/' + $('#locked_month_id').val());
}
