//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_self

$(function() {
    $("input.date").datepicker({maxDate: getFirstOfNextMonth(),
                                dateFormat: 'yy-mm-dd'});
    memberNameAutocomplete();
    $("#standby_start_date").change(standbyStartDateSelect);
    
    $(document).on('click', 'a.submit', function() {
      $(this).parent('form').submit();
      return false;
    });
    
    $("a.button").button();
    $("input[type='submit']").button();
    flash_dialog($('div.flash:has(p)'));
});

function ajax_flash (elem, msg) {
  elem.html('<p>' + msg + '</p>');
  flash_dialog(elem);
}

$(document).ajaxComplete(function(event, request) {
  notice = request.getResponseHeader('X-FlashNotice');
  if (notice) ajax_flash($('#flashnotice'), notice);
})

$(document).ajaxError(function(event, request) {
  warning = request.getResponseHeader('X-FlashWarning');
  if (warning) ajax_flash($('#flashwarning'), warning);
})

function getFirstOfNextMonth() {
  var today = new Date();
  var nextMonth = new Date(today.getFullYear(), today.getMonth() + 1, 1);
  return new Date(nextMonth - 1);
}

function standbyStartDateSelect() {
  $("#standby_end_date").val($(this).val());
}

function memberNameAutocomplete() {
  var members;
  var callback = function(request, response) {
    $.get($("#member_name").parents("form").attr("action"),
    {term: encodeURIComponent(request.term), format: 'json'},
	  function(data) {
      members = data
      response($.map(members, function(e, i) {
        m = e.member;
        return {
          value: m.id,
          label: m.firstname + " " + m.lastname + " (#" + m.badgeno + ")"
        }        
      }));
	  });
  }

  var select = function(event, ui) {
    document.location = $('#member_name').parents('form').attr('action') + '/' + ui.item.value;
    return false;
  }

  var submit = function() {
    if ((members != null) && (members.length == 1)) {
      document.location = $(this).attr("action") + "/" + members[0].member.id;
    }

    return false;
  }

  $("#member_name").autocomplete({
    source: callback,
	  select: select,
	  minLength: 3,
	  messages: {
	    noResults: '',
	    results: function() {}
	  }
	});	
  $("#member_name").parents("form").submit(submit);
}

function flash_dialog(elem) {
  elem.dialog({modal: true,
	buttons: {"Ok": function() {
	  $(this).dialog('destroy');
	  $(this).hide();
  }}});
  elem.show();
}
