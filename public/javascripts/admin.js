$(function() {
    $('#admintabs').tabs();
    $('#reportform').submit(monthlyReport);
    $("#unlock_month_form").submit(unlock_month_form);
    $('#accordion').accordion();
  });

function monthlyReport() {
   $.get('/reports/' + $('#month').val(),
	null,
	null,
	'script');
  return false;
}

function unlock_month_form() {
  var form = $('#unlock_month_form');
  var action = form.attr('action');
  form.attr('action', action + '/' + $('#locked_month_id').val());
}