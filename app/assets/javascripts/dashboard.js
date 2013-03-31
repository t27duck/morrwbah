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
    $entry_list.data('feed-id', $(this).data("id"));
    populateEntryList($(this).data("id"));
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
    var read = '/images/silk/icons/email.png';
    var unread = '/images/silk/icons/email_open.png';
    var $entry = $(this).parent().parent();
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

  $('#feed-entry-list').on('change', '#feed-view', function() {
    var feed_id = $(this).parent().parent().data('id');
    var feed_view = $(this).val();
    populateEntryList(feed_id, feed_view);
  });

  function populateEntryList(feed_id, feed_view) {
    if (typeof feed_view === 'undefined') {
      feed_view = 'unread';
    }
    $.get('feeds/'+feed_id, {feed_view: feed_view}, function(data) {
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

  setSortableOnFeedList();
  $(window).trigger('resize');

});
