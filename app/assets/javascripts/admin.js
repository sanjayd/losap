//= require jquery.cookie
//= require_self

$(function() {
  $('#accordion').accordion();
  $('#admintabs').tabs({cookie: {expires: 1}});

  $('#monthly_report_form')
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
  
  $('.data-delete').click(function(event) {
    var deleteUrl = $(this).attr('href');
    var page = $('.apple_pagination .current').text() || 1;
    $.ajax({
      url: deleteUrl,
      method: 'delete',
      dataType: 'json',
      complete: function(response) {
        $.get('/members?page=' + page, function(response) {
          $('#tab-3').html(response);
          $('#tab-3 .button').button();
        });
      }
    })
    return false;
  });
});

function unlock_month_form() {
  var form = $('#unlock_month_form');
  var action = form.attr('action');
  form.attr('action', action + '/' + $('#locked_month_id').val());
}
