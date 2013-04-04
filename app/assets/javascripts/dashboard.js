$(document).ready(function() {

  $.ajaxSetup({
    'beforeSend': function(xhr) {
      xhr.setRequestHeader('X-CSRF-Token', $("meta[name='csrf-token']").attr('content'));
    },
    cache: false
  });

  $(document).bind('keyup', 'j', function(e) {
    selectNextEntry('next');
  });

  $(document).bind('keyup', 'k', function(e) {
    selectNextEntry('prev');
  });

  // A feed is selected
  $('#feed-list').on('click', '.feed-title', function() {
    var $entry_list = $('#entry-list');
    $entry_list.data('id', $(this).data("id"));
    $entry_list.data('type', 'feed');
    populateEntryList($(this).data("id"), 'unread', 'feed');
  });

  // A folder is selected
  $('#feed-list').on('click', '.folder-title>div', function() {
    var $entry_list = $('#entry-list');
    $entry_list.data('id', $(this).parent().data("id"));
    $entry_list.data('type', 'folder');
    populateEntryList($(this).parent().data("id"), 'unread', 'folder');
  });

  $('#feed-list').on({
    mouseenter: function() {
      $('.config', $(this)).removeClass('hidden');
    },
    mouseleave: function() {
      $('.config', $(this)).addClass('hidden');
    }
  }, '.folder-title>div, .feed-title>div');


  $('#feed-list').on('click', '.config', function(e) {
    e.stopPropagation();
  });

  // A feed entry is selected
  $('#feed-entry-list').on('click', '.title', function() {
    var $entry = $(this).parent().parent();
    var feed_id = $entry.data('feed-id');
    var entry_id = $entry.data('id');
    $('#entry-list .entry .entry-content').remove();
    if (!$entry.hasClass('selected')) {
      $('#entry-list .entry').removeClass('selected');
      $entry.addClass('selected');
      $.ajax({
        url: '/feeds/'+feed_id+'/entries/'+entry_id, 
        type: 'GET', 
        cache: false,
        async: false,
        beforeSend: function ( xhr ) {
          $entry.append('<div class="entry-content"><img src="/images/ajax-loader.gif" /></div>');
        }
      }).done(function(data) {
        $('.entry-content', $entry).html(data);$entry[0].scrollIntoView(true);
        if ($entry.hasClass('unread')) {
          $('.read-status', $entry).trigger('click');
        }
      });
      
    }
  });

  // Read/Unread
  $('#feed-entry-list').on('click', '.read-status', function() {
    var read = '/images/silk/icons/email_open.png';
    var unread = '/images/silk/icons/email.png';
    var $entry = $(this).parent().parent();
    var action, data, direction;
    if ($entry.hasClass('unread')) {
      $entry.removeClass('unread');
      $entry.addClass('read');
      $(this).children('img').attr('src', read);
      action = true;
      direction = 'down';
    } else {
      $entry.removeClass('read');
      $entry.addClass('unread');
      $(this).children('img').attr('src', unread);
      action = false;
      direction = 'up';
    }

    data = {"read": action};
    updateUnreadCount($entry.data('feed-id'), direction)
    updateEntry($entry, data);
  });

  // Starred/Unstarred
  $('#feed-entry-list').on('click', '.starred-status', function() {
    var unstarred = '/images/silk/icons/star_gray.png';
    var starred = '/images/silk/icons/star.png';
    var $entry = $(this).parent().parent();
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
    updateEntry($entry, data);
  });
  
  $('#feed-entry-list').on('click', '.entry-link', function() {
    var $entry = $(this).parent().parent();
    if ($entry.hasClass('unread')) {
      $('.read-status', $entry).trigger('click');
    }
  });

  $('#feed-entry-list').on('click', '#fetch-feed', function() {
    var id = $(this).parent().parent().data('id');
    var type = $(this).parent().parent().data('type');
    var filter = $(this).parent().children('#filter').val();
    populateEntryList(id, filter, type);
  });


  $('#feed-entry-list').on('change', '#filter', function() {
    var id = $(this).parent().parent().data('id');
    var type = $(this).parent().parent().data('type');
    var filter = $(this).val();
    populateEntryList(id, filter, type);
  });

  $(window).resize(function() {
    if ($('#entry-list').size() > 0) {
      $('#feed-list').height($(window).height() - $('#feed-list').offset().top - 50);
      $('#entry-list').height($(window).height() - $('#entry-list').offset().top - 15);
    }
  });

  setSortableOnFeedList();
  $(window).trigger('resize');

});
