$(document).ready(function() { 
  $(document).bind("keyup", "j", function() {
    $("#next-entry").trigger("click");
  });
  
  $(document).bind("keyup", "k", function() {
    $("#prev-entry").trigger("click");
  });
  
  $("#next-entry").on("click", function() {
    var $current = $(".panel-collapse.in");
    var $next;
    if ($current.size() > 0) {
      $next = $current.parent().next();
      if ($next.size() > 0) {
        $next.children(".panel-heading").trigger("click");
      }
    } else {
      $(".panel-heading:first").trigger("click");
    }
  });

  $("#prev-entry").on("click", function() {
    var $current = $(".panel-collapse.in");
    var $prev;
    if ($current.size() > 0) {
      $prev = $current.parent().prev();
      if ($prev.size() > 0) {
        $prev.children(".panel-heading").trigger("click");
      }
    } else {
      $(".panel-heading:last").trigger("click");
    }
  });

  $(".panel-heading").on("click", function() {
    event.preventDefault();

    $(".panel-collapse.in").each(function() {
      $(this).removeClass("in");
      $(this).children(".panel-body").html("");
    });
    
    var $this = $(this);
    var $body = $this.parent().children(".panel-collapse");
    var $body_inner = $body.children(".panel-body");
    var id = $body.data("entry-id");
    $.ajax({
      url: "/entries/"+id, 
      type: "GET"
    }).done(function(data) {
      $body_inner.html(data);
      $body_inner.fitVids();
      $body.addClass("in");
      $this[0].scrollIntoView(true);
    });
  });

  $("#entry-list").on("click", ".star-entry", function() {
    var id = $(this).data("entry-id");
    var current = $(this).data("starred-state");
  });

  $("#entry-list").on("click", ".read-entry", function() {
  });

  $(window).resize(function() {
    if ($("#entry-list").size() > 0) {
      $("#entry-list").height($(window).height() - $("#entry-list").offset().top - 15);
    }
  });

  $(window).trigger("resize");
});
