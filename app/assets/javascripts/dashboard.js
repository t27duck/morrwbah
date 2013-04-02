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

  function selectNextEntry(direction) {
     var $selected_entry = $('#feed-entry-list .entry.selected');
     var $next_selected;
     if ($selected_entry.size() > 0) {
       if (direction === 'prev') {
         $next_selected = $selected_entry.prev();
       } else {
         $next_selected = $selected_entry.next();
       }
     } else {
       if (direction === 'prev') {
         $next_selected = $('#feed-entry-list .entry').last();
       } else {
         $next_selected = $('#feed-entry-list .entry').first();
       }
     }

     if ($next_selected.size() === 0) {
       return;
     }
     $('.title', $next_selected).trigger('click');
  }


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

  $('#feed-entry-list').on('click', '#fetch-feed', function() {
    var id = $(this).parent().parent().data('id');
    var type = $(this).parent().parent().data('type');
    var feed_view = $(this).parent().children('#feed-view').val();
    populateEntryList(id, feed_view, type);
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

  $('#feed-entry-list').on('change', '#feed-view', function() {
    var id = $(this).parent().parent().data('id');
    var type = $(this).parent().parent().data('type');
    var feed_view = $(this).val();
    populateEntryList(id, feed_view, type);
  });

  function populateEntryList(id, feed_view, type) {
    if (typeof feed_view === 'undefined') {
      feed_view = 'unread';
    }  
    $.ajax({
      url: type+'s/'+id, 
      data: {feed_view: feed_view},
      type: 'GET',
      beforeSend: function() {
        $('#loading-notice.notice').removeClass('hidden');
      }
    }).done(function(data) {
      $('#feed-entry-list').html(data);
      refreashFeedList(type, id);
      $('#loading-notice.notice').addClass('hidden');
      $(window).trigger('resize');
    });
  }

  function refreashFeedList(type, active_id) {
    $.get('feeds', function(data) {
      $('#feed-list').html(data);
      $('#feed-list .feed-title div').removeClass('selected');
      $('#feed-list .folder-title div').removeClass('selected');
      if (typeof active_id != 'undefined') {
        $("."+type+"-title[data-id='"+active_id+"']").children('div').addClass('selected');
      }
      setSortableOnFeedList();
    });
  }

  $(window).resize(function() {
    if ($('#entry-list').size() > 0) {
      $('#feed-list').height($(window).height() - $('#feed-list').offset().top - 50);
      $('#entry-list').height($(window).height() - $('#entry-list').offset().top - 15);
    }
  });

  function setSortableOnFeedList() {
    $('.sortable', '#feed-list').nestedSortable({
      forcePlaceholderSize: true,
      handle: 'div',
      items: 'li',
      opacity: .6,
      placeholder: 'placeholder',
      tabSize: 0,
      toleranceElement: '> div',
      maxLevels: 2,
      isTree: true,
      protectRoot: true,
      axis: 'y',
      update: function(event, ui) {
        var folder_structure_data = $(this).nestedSortable('toHierarchy');
        $.ajax({
          type: "POST",
          url: "/folders/update_order.json",
          data: JSON.stringify({folder_structure: folder_structure_data}),
          contentType: "application/json; charset=utf-8",
          dataType: "json",
        }).done(function(data, textStatus, jqXHR) {
        }).fail(function(jqXHR, textStatus, errorThrown) {
        });
      }
    });
  }

  function updateUnreadCount(feed_id, direction) {
    var $feed_title = $('#feed-'+feed_id+'.feed-title');
    var $folder_title = $feed_title.closest('li.folder-title');
    var $all_items = $('#all-items.feed-title');
    adjustUnreadCountOnElement($feed_title, direction);
    adjustUnreadCountOnElement($folder_title, direction);
    adjustUnreadCountOnElement($all_items, direction);
  }

  function adjustUnreadCountOnElement($elm, direction) {
    var current_unread = $elm.data('unread-count');
    var $div_handle = $('div:first', $elm);
    var $unread_count_span = $('span.unread-count:first', $elm);
    var new_unread;
    if (direction === 'up') {
      new_unread = current_unread + 1;
    } else {
      new_unread = current_unread - 1;
    }

    $elm.data('unread-count', new_unread);
    if (new_unread > 0) {
      $div_handle.addClass('unread');
      $unread_count_span.html('('+new_unread+')');
    } else {
      $div_handle.removeClass('unread');
      $unread_count_span.html('');
    }
  }

  setSortableOnFeedList();
  $(window).trigger('resize');

});
