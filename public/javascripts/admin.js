$(function() {
    $('#admintabs').tabs();
    $('#reportform').submit(monthlyReport);
  });

function monthlyReport() {
  $.get('/reports/' + $('#year').val() + '/' + $('#month').val(),
	null,
	null,
	'script');
  return false;
}
