// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.ajaxSetup({
    'beforeSend': function(xhr) {
      xhr.setRequestHeader("Accept", "text/javascript")}
  });

$(function() {
    $("#newmember").button();
    $("input.date").datepicker({maxDate: getFirstOfNextMonth(),
                                dateFormat: 'yy-mm-dd'});
    memberNameAutocomplete();
    $("#standby_start_date").change(standbyStartDateSelect);
    $("#member_name").focusin(function() {
	    $("#newmemberdiv").hide("blind");
    });
    $("#member_name").focusout(function() {
	    $("#newmemberdiv").show("blind");
    });
    $("a.delete_sleep_in").click(delete_sleep_in);
    $("a.delete_standby").click(delete_standby);
    $("a.undelete_sleep_in").click(undelete_sleep_in);
    $("a.undelete_standby").click(undelete_standby);
    $("a.button").button();
    $("input[type='submit']").button();
    flash_dialogs();
  });

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
    {term: encodeURIComponent(request.term)},
	  function(data) {
	    members = $.map($.parseJSON(data), function(e, i) {
		m = e.member;
		return {id: m.id,
		    string: m.firstname + " " + m.lastname + " (#" + m.badgeno + ")"};
	      });

	    response($.map(members, function(e, i) {
		  return e.string;
		}));
	  });
  }

  var select = function(event, ui) {
    var item = ui.item.value;
    var i;

    for(i in members) {
      var member = members[i];
      if (member.string == item) {
	document.location = $("#member_name").parents("form").attr("action") + "/" + member.id;
      }
    }
  }

  var submit = function() {
    if ((members != null) && (members.length == 1)) {
      document.location = $(this).attr("action") + "/" + members[0].id;
    }

    return false;
  }

  $("#member_name").autocomplete({source: callback,
	select: select,
	minLength: 3});	
  $("#member_name").parents("form").submit(submit);
}

function delete_sleep_in() {
  $.post($(this).attr('href'),
	 {_method: 'put',
	     "sleep_in[deleted]": 'true'},
	 function(data, status) {
	   if (status == "success") {
	     document.location.reload();
	   }
	 });
  return false;
}

function delete_standby() {
  $.post($(this).attr('href'),
	 {_method: 'put',
	     'standby[deleted]': 'true'},
	 function(data, status) {
	   if (status == 'success') {
	     document.location.reload();
	   }
	 });
  return false;
}

function flash_dialogs() {
  $('div.flash').dialog({modal: true,
	buttons: {"Ok": function() {
	  $(this).dialog('destroy');
	  $(this).remove();
  }}});
}

function undelete_sleep_in() {
  $.post($(this).attr('href'),
	 {_method: 'put',
	     "sleep_in[deleted]": 'false'},
	 function(data, status) {
	   if (status == "success") {
	     document.location.reload();
	   }
	 });
  return false;
}

function undelete_standby() {
  $.post($(this).attr('href'),
	 {_method: 'put',
	     "standby[deleted]": 'false'},
	 function(data, status) {
	   if (status == "success") {
	     document.location.reload();
	   }
	 });
  return false;
}
