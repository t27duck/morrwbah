$(document).ready(function() { 
  $(".accordion-body").on("show", function() {
    var $this = $(this);
    var $inner = $this.children(".accordion-inner");
  });


  $(".accordion-body").on("hidden", function() {
    var $this = $(this);
    var $inner = $this.children(".accordion-inner");
    $inner.html("");
  });
});
