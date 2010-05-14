$(function() {
    $('#admintabs').tabs();
    $('#reportform').submit(monthlyReport);
  });

function monthlyReport() {
  $.get('/reports/' + $('#year').val() + '/' + $('#month').val(),
	function(data) {
	  $('#report').val(data);
	});
  return false;
}
