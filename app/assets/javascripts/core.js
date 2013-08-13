$(document).ready(function() { 
  $(document).bind('keyup', 'j', function(e) {
    var $current = $(".accordion-body.in");
    var $next;
    if ($current.size() > 0) {
      $next = $current.parent().next();
      if ($next.size() > 0) {
        $next.children(".accordion-heading").trigger("click");
      }
    } else {
      $(".accordion-heading:first").trigger("click");
    }
  });

  $(document).bind('keyup', 'k', function(e) {
    var $current = $(".accordion-body.in");
    var $prev;
    if ($current.size() > 0) {
      $prev = $current.parent().prev();
      if ($prev.size() > 0) {
        $prev.children(".accordion-heading").trigger("click");
      }
    } else {
      $(".accordion-heading:last").trigger("click");
    }

  });

  $(".accordion-heading").on("click", function() {
    event.preventDefault();

    $(".accordion-body.in").each(function() {
      $(this).removeClass("in");
      $(this).children(".accordion-inner").html("");
    });
    
    var $this = $(this);
    var $body = $this.parent().children(".accordion-body");
    var $body_inner = $body.children(".accordion-inner");
    var id = $body.data("entry-id");
    $.ajax({
      url: "/entries/"+id, 
      type: "GET"
    }).done(function(data) {
      $body_inner.html(data);
      $body.addClass("in");
      $this[0].scrollIntoView(true);
    });

  });

  $(window).resize(function() {
    if ($('#entry-list').size() > 0) {
      $('#entry-list').height($(window).height() - $('#entry-list').offset().top - 15);
    }
  });

  $(window).trigger('resize');
});
