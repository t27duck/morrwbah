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

  $('#feed-list').on('click', '.folder-title>div, .feed-title>div', function() {
    var id = $(this).parent().data('id');
    var type = $(this).parent().data('type');
    populateEntryList(id, 'unread', type);
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
    var $entry = $(this).parent().parent();
    if ($entry.hasClass('unread')) {
      $entry.removeClass('unread').addClass('read');
      $(this).children('img').attr('src', '/images/silk/icons/email_open.png');
      updateUnreadCount($entry.data('feed-id'), 'down')
      updateEntry($entry, {"read": true});
    } else {
      $entry.removeClass('read').addClass('unread');
      $(this).children('img').attr('src', '/images/silk/icons/email.png');
      updateUnreadCount($entry.data('feed-id'), 'up')
      updateEntry($entry, {"read": false});
    }
  });

  // Starred/Unstarred
  $('#feed-entry-list').on('click', '.starred-status', function() {
    var $entry = $(this).parent().parent();
    if ($entry.hasClass('unstarred')) {
      $entry.removeClass('unstarred').addClass('starred');
      $(this).children('img').attr('src', '/images/silk/icons/star.png');
      updateEntry($entry, {'starred': true});
    } else {
      $entry.removeClass('starred').addClass('unstarred');
      $(this).children('img').attr('src', '/images/silk/icons/star_gray.png');
      updateEntry($entry, {'starred': false});
    }
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
    $('#feed-list').height($(window).height() - $('#feed-list').offset().top - 5);
    if ($('#entry-list').size() > 0) {
      $('#entry-list').height($(window).height() - $('#entry-list').offset().top - 15);
    }
  });

  setSortableOnFeedList();
  $(window).trigger('resize');
  $('#all-items>div').trigger('click');
});
