$(document).ready(function() {

  $.ajaxSetup({
    'beforeSend': function(xhr) {
      xhr.setRequestHeader('X-CSRF-Token', $("meta[name='csrf-token']").attr('content'));
    },
    cache: false
  });

  $(document).bind('keyup', 'j', function(e) {
    console.log('j was pressed');
  });

  // A feed is selected
  $('#feed-list').on('click', '.feed-title', function() {
    var $entry_list = $('#entry-list');
    $entry_list.data('feed-id', $(this).data("id"));
    populateEntryList($(this).data("id"));
  });

  // A feed entry is selected
  $('#feed-entry-list').on('click', '.title', function() {
    var $entry = $(this).parent();
    var feed_id = $entry.data('feed-id');
    var entry_id = $entry.data('id');
    $('#entry-list .entry').removeClass('selected');
    $(this).addClass('selected');
    $.get('feeds/'+feed_id+'/entries/'+entry_id, function(data) {
      $('#entry-display').html(data);
    });
    if ($entry.hasClass('unread')) {
      $entry.children('.read-status').trigger('click');
    }
  });

  // Read/Unread
  $('#feed-entry-list').on('click', '.read-status', function() {
    var read = '/images/silk/icons/email.png';
    var unread = '/images/silk/icons/email_open.png';
    var $entry = $(this).parent();
    var action, data;
    if ($entry.hasClass('unread')) {
      $entry.removeClass('unread');
      $entry.addClass('read');
      $(this).children('img').attr('src', read);
      action = true;
    } else {
      $entry.removeClass('read');
      $entry.addClass('unread');
      $(this).children('img').attr('src', unread);
      action = false;
    }

    data = {"read": action};
    console.log('read');
    updateEntry($entry, data);
  });

  // Starred/Unstarred
  $('#feed-entry-list').on('click', '.starred-status', function() {
    var unstarred = '/images/silk/icons/star_gray.png';
    var starred = '/images/silk/icons/star.png';
    var $entry = $(this).parent();
    var action, data;
    if ($entry.hasClass('unstarred')) {
      $entry.removeClass('unstarred');
      $entry.addClass('starred');
      $(this).children('img').attr('src', starred);
      action = true;
    } else {
      $entry.removeClass('starred');
      $entry.addClass('unstarred');
      $(this).children('img').attr('src', unstarred);
      action = false;
    }

    data = {"starred": action};
    console.log('star');
    updateEntry($entry, data);
  });

  function updateEntry($entry, data) {
    var params = {'_method': 'put', 'entry': data};
    var feed_id = $entry.data('feed-id');
    var entry_id = $entry.data('id');
    $.ajax({
      url: '/feeds/'+feed_id+'/entries/'+entry_id, 
      type: 'POST', 
      data: params
    }).done(function() { });
  }

  function populateEntryList(feed_id) {
    $.get('feeds/'+feed_id, function(data) {
      $('#feed-entry-list').html(data);
      refreashFeedList(feed_id);
      $(window).trigger('resize');
    });
  }

  function refreashFeedList(active_feed_id) {
    $.get('feeds', function(data) {
      $('#feed-list').html(data);
      $('#feed-list .feed-title div').removeClass('selected');
      if (typeof active_feed_id != 'undefined') {
        $('div', $(".feed-title[data-id='"+active_feed_id+"']") ).addClass('selected');
      }
    });
  }

  $(window).resize(function() {
    if ($('#entry-display').size() > 0) {
      $('#feed-list').height($(window).height() - $('#feed-list').offset().top - 50);
      $('#entry-display').height($(window).height() - $('#entry-display').offset().top - 15);
    }
  });
  
  $(window).trigger('resize');

  $('#feed-entry-list').on('click', '.entry .title', function() {
    $(this).parent()[0].scrollIntoView(true);
    $('#entry-list .entry').removeClass('selected');
    $(this).addClass('selected');
  });

});
