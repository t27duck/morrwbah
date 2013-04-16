entry_ids = [];
entry_list_url_params = "";
$( document ).on( "pageinit", "[data-role='page']#entry-list", function() {
  entry_ids = $(this).data('entry-ids').toString().split(",");
});

$(document).ready(function() {
  $.ajaxSetup({
    'beforeSend': function(xhr) {
      xhr.setRequestHeader('X-CSRF-Token', $("meta[name='csrf-token']").attr('content'));
    }
  });
  
});

$(document).on("pageinit", "[data-role='page'].view-entry", function() {
  $('.view-entry').on('click', '.mark-read', function() {
    var $entry = $(this);
    if ($entry.hasClass('unread')) {
      $entry.removeClass('unread').addClass('read');
      $(this).find('img').attr('src', '/images/silk/icons/email_open.png');
      updateEntry($entry.data('id'), {"read": true});
    } else {
      $entry.removeClass('read').addClass('unread');
      $(this).find('img').attr('src', '/images/silk/icons/email.png');
      updateEntry($entry.data('id'), {"read": false});
    }
  });

  $('.view-entry').on('click', '.mark-starred', function() {
    var $entry = $(this);
    if ($entry.hasClass('unstarred')) {
      $entry.removeClass('unstarred').addClass('starred');
      $(this).find('img').attr('src', '/images/silk/icons/star.png');
      updateEntry($entry.data('id'), {"starred": true});
    } else {
      $entry.removeClass('starred').addClass('unstarred');
      $(this).find('img').attr('src', '/images/silk/icons/star_gray.png');
      updateEntry($entry.data('id'), {"starred": false});
    }
  });

  var current_id = $(this).data("id");
  entry_list_url_params = $(this).data("entry-list-url-params");
  var page = "#" + $( this ).attr("id");
  var current_pos = $.inArray(current_id.toString(), entry_ids);
  var next = 0;
  var prev = 0;
  if (current_pos !== -1) {
    if (current_pos > 0) {
      prev = parseInt(entry_ids[current_pos-1]);
    }
    if (current_pos < entry_ids.length-1) {
      next = parseInt(entry_ids[current_pos+1]);
    }
  }

  if (next > 0) {
    var next_url = "/entries/"+next+"/?"+entry_list_url_params;
    // $( document ).on( "swipeleft", page, function() {
    $( page ).on( "swipeleft", function() {
      $.mobile.changePage(next_url, { transition: "slide" });
    });
    $( ".control .next", page ).on( "click", function() {
      $.mobile.changePage(next_url, { transition: "slide" } );
    });
  } else {
    $(".control .next", page).addClass( "ui-disabled" );
  }

  if (prev > 0) {
    var prev_url = "/entries/"+prev+"/?"+entry_list_url_params;
    // $( document ).on( "swiperight", page, function() {
    $( page ).on( "swiperight", function() {
      $.mobile.changePage(prev_url, { transition: "slide", reverse: true } );
    });
    $( ".control .prev", page ).on( "click", function() {
      $.mobile.changePage(prev_url, { transition: "slide", reverse: true } );
    });
  } else {
    $(".control .prev", page).addClass( "ui-disabled" );
  }

});

function updateEntry(entry_id, data) {
  var params = {'_method': 'put', 'entry': data};
  $.ajax({
    url: '/entries/'+entry_id, 
    type: 'POST', 
    data: params
  }).done(function() { });
}