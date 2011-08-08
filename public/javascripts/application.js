// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

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
    
    $('a.submit').live('click', function() {
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
	    members = $.map(data, function(e, i) {
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

function flash_dialog(elem) {
  elem.dialog({modal: true,
	buttons: {"Ok": function() {
	  $(this).dialog('destroy');
	  $(this).hide();
  }}});
  elem.show();
}
