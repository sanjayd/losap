$(function() {
    $('#accordion').accordion();
    $('#admintabs').tabs({cookie: {expires: 1}});
    $('#reportform').submit(monthlyReport);
    $('#annualreportform').submit(annualReport);
    $("#unlock_month_form").submit(unlock_month_form);
    $('#members').tablesorter({headers: {2: {sorter: false},
                                         3: {sorter: false}},
                               sortList: [[1, 0], [0, 0]]
                               });
  });

function monthlyReport() {
   $.get('/reports/' + $('#month').val(),
	null,
	null,
	'script');
  return false;
}

function annualReport() {
  this.action = '/reports/' + $('#year').val();
  this.target='_blank';
  return true;
}

function unlock_month_form() {
  var form = $('#unlock_month_form');
  var action = form.attr('action');
  form.attr('action', action + '/' + $('#locked_month_id').val());
}
