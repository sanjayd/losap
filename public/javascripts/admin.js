$(function() {
    $('#admintabs').tabs();
    $('#reportform').submit(monthlyReport);
  });

function monthlyReport() {
   $.get('/reports/' + $('#month').val(),
	null,
	null,
	'script');
  return false;
}
