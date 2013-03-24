$(document).ready(function() {
  $('#feed-list').on('click', '.feed-title', function() {
    var $entry_list = $('#entry-list');
    $entry_list.children().each(function() { $(this).remove(); });
    $entry_list.html('<div id="feed-title">'+$(this).data('full-title')+'</div>');
    $entry_list.append('<div id="entries"></div>');
    $entry_list.data('page', 1);
    $entry_list.data('feed-id', $(this).data("id"));
    $entry_list.data('possible-more-data', '1');
    populateEntryList($(this).data("id"), 1);
  });

  function populateEntryList(feed_id, page) {
    $.get('feeds/'+feed_id, {'page': page}, function(data) {
      if ($.trim(data) === '') {
        $('#entry-list').data('possible-more-data', '0');
      } else {
        $('#entry-list').data('possible-more-data', '1');
        $('#entry-list #entries').append(data);
        refreashFeedList(feed_id);
      }
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
    $('#entry-list').height($(window).height() - $('#entry-list').offset().top - 50);
  });
  
  $(window).trigger('resize');

  $('#entry-list').scroll(function() {
    var active_id = 0;
    var current_active_id = $('#entry-list').data('active-id');
    var entry_list_height = $('#entry-list').height();
    
    $('.entry').each(function() {
      var entry_top = $(this).offset().top;
      var entry_height = $(this).height();
      var entry_top_and_height = $(this).offset().top + (entry_list_height / 2) + 30;
      var shift_check;

      if (entry_height > entry_list_height) {
        shift_check = entry_top_and_height;
      } else {
        shift_check = entry_top;
      }
      
      if (shift_check >= 0) {
        active_id = $(this).data('id');
        return false;
      }
    });
    
    if (active_id != current_active_id) {
      $('#entry-list .entry').removeClass('selected');
      $("#entry-list .entry[data-id='"+active_id+"']").addClass('selected');
      current_active_id = active_id;
    }
    
    if ($('#entry-list').scrollTop() > entry_list_height) {
      if ($('#entry-list').data('possible-more-data') === '1') {
        var feed_id = $('#entry-list').data('feed-id');
        var page = $('#entry-list').data('page') + 1;
        $('#entry-list').data('page', page);
        populateEntryList(feed_id, page);
      }
    }
  });

  $('#entry-list').on('click', '.entry', function() {
    $(this)[0].scrollIntoView(true);
    $('#entry-list .entry').removeClass('selected');
    $(this).addClass('selected');
  });

});
