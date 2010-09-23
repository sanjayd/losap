$(function() {
    $('#accordion').accordion();
    $('#admintabs').tabs({cookie: {expires: 1}});
    $('#reportform').submit(monthlyReport);
    $('#annualreportform').submit(annualReport);
    $("#unlock_month_form").submit(unlock_month_form);
  });

function monthlyReport() {
  $.ajax({
    url: '/reports/' + $('#month').val(),
    beforeSend: function(request) {
      $('#reportpending').css('visibility', 'visible');
    },
    success: function(data) {
      $('#reportpending').css('visibility', 'hidden');
    },
    dataType: 'script'
  });
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
